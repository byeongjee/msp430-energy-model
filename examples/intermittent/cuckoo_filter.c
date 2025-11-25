#include "setup.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define NUM_BUCKETS 256 // must be a power of 2
#define MAX_RELOCATIONS 8

typedef uint16_t value_t;
typedef uint16_t hash_t;
typedef uint16_t fingerprint_t;
typedef uint16_t index_t; // bucket index

// --- Simulation Configuration ---

// We aim to fill 50% of the buckets for this demo
#define NUM_KEYS (NUM_BUCKETS / 2)
#define INIT_KEY 0x1

// LED Config for FR5994 LaunchPad
#define LED1_PIN BIT0 // P1.0 (Red)
#define LED2_PIN BIT1 // P1.1 (Green)

// Storage for the filter (Zero initialized by startup code or explicit loop)
static fingerprint_t filter[NUM_BUCKETS];


// --- Core Cuckoo Logic ---

static hash_t djb_hash(uint8_t *data, unsigned len) {
  uint32_t hash = 5381;
  unsigned int i;
  for (i = 0; i < len; data++, i++)
    hash = ((hash << 5) + hash) + (*data);
  return hash & 0xFFFF;
}

// Map a fingerprint to an index
static index_t hash_fp_to_index(fingerprint_t fp) {
  hash_t hash = djb_hash((uint8_t *)&fp, sizeof(fingerprint_t));
  return hash & (NUM_BUCKETS - 1);
}

// Map a key (original value) to an index
static index_t hash_key_to_index(value_t key) {
  hash_t hash = djb_hash((uint8_t *)&key, sizeof(value_t));
  return hash & (NUM_BUCKETS - 1);
}

// Generate the fingerprint (short hash) for a key
static fingerprint_t hash_to_fingerprint(value_t key) {
  fingerprint_t fp = djb_hash((uint8_t *)&key, sizeof(value_t));
  // Fingerprint cannot be 0 (0 denotes empty slot)
  return (fp == 0) ? 1 : fp;
}

// Deterministic key generator for testing
static value_t generate_key(value_t prev_key) { return (prev_key + 1) * 17; }

static bool insert(fingerprint_t *filter, value_t key) {
  fingerprint_t fp1, fp2, fp_victim, fp_next_victim;
  index_t index_victim, fp_hash_victim;
  unsigned relocation_count = 0;

  fingerprint_t fp = hash_to_fingerprint(key);
  index_t index1 = hash_key_to_index(key);
  index_t fp_hash = hash_fp_to_index(fp);

  // Cuckoo Filter Property: Index2 = Index1 XOR Hash(fingerprint)
  index_t index2 = index1 ^ fp_hash;
  // Mask again just to be safe against overflow (though XOR shouldn't overflow
  // power of 2 bounds)
  index2 &= (NUM_BUCKETS - 1);

  fp1 = filter[index1];
  if (fp1 == 0) { // Slot 1 free
    filter[index1] = fp;
    return true;
  }

  fp2 = filter[index2];
  if (fp2 == 0) { // Slot 2 free
    filter[index2] = fp;
    return true;
  }

  // Both slots full. Evict a victim.
  // Randomly choose index1 or index2 to start the kicking chain
  index_victim = (rand() & 0x80) ? index1 : index2;
  fp_victim = filter[index_victim];
  filter[index_victim] = fp; // Place new item, holding victim in hand

  // Relocation Loop (The "Cuckoo" part)
  do {
    // Calculate the "other" address for the victim
    fp_hash_victim = hash_fp_to_index(fp_victim);
    index_victim = index_victim ^ fp_hash_victim;
    index_victim &= (NUM_BUCKETS - 1);

    fp_next_victim = filter[index_victim];
    filter[index_victim] = fp_victim;

    // If the slot we moved into was not empty, we pick up the next victim
    fp_victim = fp_next_victim;
    relocation_count++;

  } while (fp_victim != 0 && relocation_count < MAX_RELOCATIONS);

  if (fp_victim != 0) {
    DEBUG_PRINTF("FAILED: Max relocations (%u) reached. Dropped FP: %04x\n",
           MAX_RELOCATIONS, fp_victim);
    return false;
  }

  return true;
}

static bool lookup(fingerprint_t *filter, value_t key) {
  fingerprint_t fp = hash_to_fingerprint(key);
  index_t index1 = hash_key_to_index(key);
  index_t fp_hash = hash_fp_to_index(fp);
  index_t index2 = (index1 ^ fp_hash) & (NUM_BUCKETS - 1);

  if (filter[index1] == fp)
    return true;
  if (filter[index2] == fp)
    return true;
  return false;
}

// --- Visualization ---

void print_filter(fingerprint_t *f) {
  DEBUG_PRINTF("\n--- Filter State (Partial View) ---\n");
  int occupied = 0;
  // Only printing first 64 buckets to save UART time, or all if you prefer
  for (int i = 0; i < NUM_BUCKETS; i++) {
    if (f[i] != 0) {
      occupied++;
      if (i < 32) { // Just print first 32 non-empty slots to keep log clean
        DEBUG_PRINTF("[%03u]: %04x  ", i, f[i]);
        if (occupied % 4 == 0)
          DEBUG_PRINTF("\r\n");
      }
    }
  }
  DEBUG_PRINTF("\nTotal Occupied: %u / %u\n", occupied, NUM_BUCKETS);
  DEBUG_PRINTF("--------------------\n");
}

// --- Main ---

int main() {
  initialize();

  __enable_interrupt();

  // Clear Filter
  for (int i = 0; i < NUM_BUCKETS; i++)
    filter[i] = 0;

  DEBUG_PRINTF("\n\n=== Cuckoo Filter Demo (Updated) ===\n");
  DEBUG_PRINTF("Buckets: %u, Relocation Limit: %u\n", NUM_BUCKETS, MAX_RELOCATIONS);
  DEBUG_PRINTF("Attempting to insert %u keys...\n", NUM_KEYS);

  value_t key = INIT_KEY;
  unsigned inserts = 0;

  // 1. Insertion Phase
  DEBUG_PRINTF("\n[Phase 1] Inserting...\n");
  for (int i = 0; i < NUM_KEYS; ++i) {
    key = generate_key(key);
    bool success = insert(filter, key);

    if (success)
      inserts++;

    // Blink Red LED on success
    P1OUT ^= LED1_PIN;
    __delay_cycles(5000);
  }

  print_filter(filter);
  DEBUG_PRINTF("Insert Success Rate: %u / %u\n", inserts, NUM_KEYS);

  // 2. Verification Phase
  DEBUG_PRINTF("\n[Phase 2] Verifying...\n");
  key = INIT_KEY; // Reset key generator
  unsigned found = 0;

  for (int i = 0; i < NUM_KEYS; ++i) {
    key = generate_key(key);
    bool member = lookup(filter, key);

    if (member)
      found++;
    else {
      // This is expected if 'insert' failed earlier for this key
      // printf("Key %04x missing (likely dropped during insert)\n", key);
    }

    // Blink Green LED on check
    P1OUT ^= LED2_PIN;
    __delay_cycles(5000);
  }

  DEBUG_PRINTF("Lookup Success Rate: %u / %u\n", found, NUM_KEYS);
  DEBUG_PRINTF("Demo Complete.\n");

  while (1)
    ;
  return 0;
}