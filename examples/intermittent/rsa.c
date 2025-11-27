#include "setup.h"
#include <stdbool.h>
#include <stdint.h>

// --- Configuration & Constants ---

// Adjust these based on your specific board headers/setup
#define PIN_LED_1 0
#define PIN_LED_2 1
#define PORT_LED_1 P1OUT
#define PORT_LED_1_DIR P1DIR
#define PORT_LED_2 P4OUT
#define PORT_LED_2_DIR P4DIR

#define VERBOSE
#define DIGIT_BITS 8
#define DIGIT_MASK 0x00ff
// Assuming KEY_SIZE_BITS is defined in keysize.h, otherwise define here
// #define KEY_SIZE_BITS 64
#include "./data/keysize.h"

#define NUM_DIGITS (KEY_SIZE_BITS / DIGIT_BITS)
#define PRINT_HEX_ASCII_COLS 8

/** @brief Type large enough to store a product of two digits */
typedef uint16_t digit_t;

typedef struct {
  uint8_t n[NUM_DIGITS]; // modulus
  digit_t e;             // exponent
} pubkey_t;

static const uint8_t PAD_DIGITS[] = {0x01};
#define NUM_PAD_DIGITS (sizeof(PAD_DIGITS) / sizeof(PAD_DIGITS[0]))

// modulus: byte order: LSB to MSB, constraint MSB>=0x80
static const pubkey_t pubkey = {
#include "./data/key.txt"
};

static const unsigned char PLAINTEXT[] =
#include "./data/plaintext.txt"
    ;

#define NUM_PLAINTEXT_BLOCKS                                                   \
  (sizeof(PLAINTEXT) / (NUM_DIGITS - NUM_PAD_DIGITS) + 1)
#define CYPHERTEXT_SIZE (NUM_PLAINTEXT_BLOCKS * NUM_DIGITS)

// --- Global Buffers (replacing Channels) ---
// We use globals to avoid stack overflow on MSP430 and mimic channel
// persistence
digit_t g_A[NUM_DIGITS];
digit_t g_B[NUM_DIGITS];
digit_t g_product[NUM_DIGITS * 2];
digit_t g_base[NUM_DIGITS * 2]; // Needs space for padding during ops
digit_t g_block[NUM_DIGITS * 2];
digit_t g_cyphertext[CYPHERTEXT_SIZE];
unsigned g_cyphertext_len = 0;

// --- Helper Functions ---


void print_hex_ascii(const uint8_t *m, unsigned len) {
  int i, j;
  for (i = 0; i < len; i += PRINT_HEX_ASCII_COLS) {
    for (j = 0; j < PRINT_HEX_ASCII_COLS && i + j < len; ++j)
      DEBUG_PRINTF("%02x ", m[i + j]);
    for (; j < PRINT_HEX_ASCII_COLS; ++j)
      DEBUG_PRINTF("   ");
    DEBUG_PRINTF(" ");
    for (j = 0; j < PRINT_HEX_ASCII_COLS && i + j < len; ++j) {
      char c = m[i + j];
      if (!(32 <= c && c <= 127))
        c = '.';
      DEBUG_PRINTF("%c", c);
    }
    DEBUG_PRINTF("\r\n");
  }
}

// Helper for 16-bit multiplication used in reduction
uint32_t mult16(digit_t a, digit_t b) { return (uint32_t)a * b; }

// --- Logic Functions (Converted Tasks) ---

// Forward declaration
void mult_mod_operation(digit_t *A, digit_t *B, digit_t *result_buffer);

/* * Performs: result = (A * B) mod N
 * This consolidates task_mult_mod, task_mult, and all task_reduce_*
 */
void mult_mod_operation(digit_t *A, digit_t *B, digit_t *result_buffer) {
  int i, j;

  // --- Original Task: task_mult_mod ---
  // (Setup phase was here, now handled by passing args)

  // --- Original Task: task_mult ---
  // Standard schoolbook multiplication: A * B -> product
  digit_t c = 0;
  digit_t p = 0;

  // Clear product buffer first
  for (i = 0; i < NUM_DIGITS * 2; i++)
    g_product[i] = 0;

  for (int digit = 0; digit < NUM_DIGITS * 2; ++digit) {
    p = c; // carry from previous
    c = 0; // new carry

    for (i = 0; i < NUM_DIGITS; ++i) {
      if (digit - i >= 0 && digit - i < NUM_DIGITS) {
        digit_t a_val = A[digit - i];
        digit_t b_val = B[i];
        uint32_t dp = (uint32_t)a_val * b_val;

        // Add to current accumulator
        p += (dp & DIGIT_MASK);
        // Calculate carry
        c += (dp >> DIGIT_BITS);
      }
    }

    // Handle local accumulator overflow
    c += (p >> DIGIT_BITS);
    p &= DIGIT_MASK;

    g_product[digit] = p;
  }

  // --- Original Task: task_reduce_digits ---
  // Find Most Significant Digit (MSD)
  int d = 2 * NUM_DIGITS;
  digit_t m;
  do {
    d--;
    m = g_product[d];
  } while (m == 0 && d > 0);

  // If result is 0, we are done
  if (m == 0) {
    for (i = 0; i < NUM_DIGITS; i++)
      result_buffer[i] = 0;
    return;
  }

  // Reduction Loop
  // The state machine looped between normalize, quotient, multiply, compare,
  // add, subtract We implement this as a while loop that reduces 'd' (current
  // digit index)

  while (1) {

    // --- Original Task: task_reduce_normalizable ---
    bool normalizable = true;
    unsigned offset = d + 1 - NUM_DIGITS;

    for (i = d; i >= 0; --i) {
      digit_t m_val = g_product[i];
      digit_t n_val = (i - offset >= 0 && i - offset < NUM_DIGITS)
                          ? pubkey.n[i - offset]
                          : 0;

      if (m_val > n_val) {
        break;
      } else if (m_val < n_val) {
        normalizable = false;
        break;
      }
    }

    if (!normalizable && d == NUM_DIGITS - 1) {
      // Reduction done: message < modulus
      break; // Exit reduction loop
    }

    if (normalizable) {
      // --- Original Task: task_reduce_normalize ---
      // Simple subtraction: product = product - (N << offset)
      unsigned borrow = 0;
      for (i = 0; i < NUM_DIGITS; ++i) {
        digit_t m_val = g_product[i + offset];
        digit_t n_val = pubkey.n[i];
        digit_t s = n_val + borrow;

        if (m_val < s) {
          m_val += (1 << DIGIT_BITS);
          borrow = 1;
        } else {
          borrow = 0;
        }
        g_product[i + offset] = m_val - s;
      }

      // Check loop bounds logic from original code
      if (offset == 0) {
        break; // Done
      }
      // Loop continues (implicit transition to n_divisor logic if offset > 0)
    } else {
      // --- Original Task: task_reduce_n_divisor ---
      digit_t n1 = pubkey.n[NUM_DIGITS - 1];
      digit_t n0 = pubkey.n[NUM_DIGITS - 2];
      digit_t n_div = ((n1 << DIGIT_BITS) + n0);

      // --- Original Task: task_reduce_quotient ---
      digit_t m2 = g_product[d];
      digit_t m1 = g_product[d - 1];
      digit_t m0 = g_product[d - 2];
      digit_t m_n = pubkey.n[NUM_DIGITS - 1];

      digit_t q;
      if (m2 == m_n) {
        q = (1 << DIGIT_BITS) - 1;
      } else {
        q = ((m2 << DIGIT_BITS) + m1) / m_n;
      }

      uint32_t n_q =
          ((uint32_t)m2 << (2 * DIGIT_BITS)) + (m1 << DIGIT_BITS) + m0;
      digit_t q_final = q + 1;
      uint32_t qn;

      do {
        q_final--;
        qn = mult16(n_div, q_final);
      } while (qn > n_q);

      // Note: d is decremented in original task here for the next loop
      // iteration We store the current 'd' for the multiply/compare steps, but
      // update it for the next loop
      unsigned current_d = d;
      d--; // Prepare for next iteration

      // --- Original Task: task_reduce_multiply ---
      // Calculate Q * N, store in temporary or directly subtract?
      // Original calculated Q*N and put it in 'product' channel via ch_qn.
      // We need a temp buffer for qn result to compare.
      digit_t qn_arr[NUM_DIGITS * 2];
      for (int k = 0; k < NUM_DIGITS * 2; k++)
        qn_arr[k] = 0;

      unsigned mul_offset = current_d - NUM_DIGITS;
      digit_t mul_c = 0;

      for (i = mul_offset; i < 2 * NUM_DIGITS; ++i) {
        digit_t m_curr = mul_c;
        if (i < mul_offset + NUM_DIGITS) {
          m_curr += q_final * pubkey.n[i - mul_offset];
        }
        mul_c = m_curr >> DIGIT_BITS;
        qn_arr[i] = m_curr & DIGIT_MASK;
      }

      // --- Original Task: task_reduce_compare ---
      char relation = '=';
      for (i = NUM_DIGITS * 2 - 1; i >= 0; --i) {
        if (g_product[i] > qn_arr[i]) {
          relation = '>';
          break;
        } else if (g_product[i] < qn_arr[i]) {
          relation = '<';
          break;
        }
      }

      if (relation == '<') {
        // --- Original Task: task_reduce_add ---
        // product = product + (N << offset)
        // Used to correct estimation error
        unsigned add_offset = current_d - NUM_DIGITS;
        digit_t add_c = 0;
        for (i = add_offset; i < 2 * NUM_DIGITS; ++i) {
          digit_t add_n =
              (i < add_offset + NUM_DIGITS) ? pubkey.n[i - add_offset] : 0;
          digit_t add_r = add_c + g_product[i] + add_n;
          add_c = add_r >> DIGIT_BITS;
          g_product[i] = add_r & DIGIT_MASK;
        }
      }

      // --- Original Task: task_reduce_subtract ---
      // product = product - Q*N (or the adjusted value)
      unsigned sub_offset = current_d - NUM_DIGITS;
      unsigned sub_borrow = 0;

      for (i = 0; i < 2 * NUM_DIGITS; ++i) {
        if (i >= sub_offset) {
          digit_t sub_qn =
              qn_arr[i]; // This is the Q*N value calculated in multiply task
          digit_t sub_s = sub_qn + sub_borrow;

          if (g_product[i] < sub_s) {
            g_product[i] += (1 << DIGIT_BITS);
            sub_borrow = 1;
          } else {
            sub_borrow = 0;
          }
          g_product[i] = g_product[i] - sub_s;
        }
      }

      // Loop continues with decremented d
    }
  }

  // Copy result to output buffer
  for (i = 0; i < NUM_DIGITS; i++) {
    result_buffer[i] = g_product[i];
  }
}

int main(void) {
  initialize();
  // --- Original Task: init ---
  // Setup GPIO (Simplification of original macros)
  PORT_LED_1_DIR |= (1 << PIN_LED_1);
  PORT_LED_2_DIR |= (1 << PIN_LED_2);

  __enable_interrupt();

  DEBUG_PRINTF(".Init.\r\n");

  // --- Original Task: task_init (Logic) ---
  unsigned message_length = sizeof(PLAINTEXT) - 1;

  DEBUG_PRINTF("Message:\r\n");
  print_hex_ascii(PLAINTEXT, message_length);
  DEBUG_PRINTF("Public key: exp = 0x%x  N = \r\n", pubkey.e);
  print_hex_ascii(pubkey.n, NUM_DIGITS);

  unsigned block_offset = 0;

  // Main Loop handling blocks
  while (block_offset < message_length) {

    // --- Original Task: task_pad ---
    DEBUG_PRINTF("pad: len=%u offset=%u\r\n", message_length, block_offset);

    // Construct the base for this block
    int i;
    for (i = 0; i < NUM_DIGITS - NUM_PAD_DIGITS; ++i) {
      g_base[i] = (block_offset + i < message_length)
                      ? PLAINTEXT[block_offset + i]
                      : 0xFF;
    }
    for (int j = 0; i < NUM_DIGITS; ++i, ++j) {
      g_base[i] = PAD_DIGITS[j];
    }

    // Initialize block (which accumulates result) to 1
    g_block[0] = 1;
    for (i = 1; i < NUM_DIGITS; ++i)
      g_block[i] = 0;

    digit_t e = pubkey.e;
    block_offset += NUM_DIGITS - NUM_PAD_DIGITS;

    // --- Original Task: task_exp (Modular Exponentiation) ---
    // Loops through bits of exponent
    DEBUG_PRINTF("exp: e=%x\r\n", e);

    while (e > 0) {
      bool multiply = e & 0x1;
      e >>= 1;

      if (multiply) {
        // --- Original Task: task_mult_block ---
        // block = (block * base) % N
        // Copy globals to temp args for clarity
        for (int k = 0; k < NUM_DIGITS; k++)
          g_A[k] = g_base[k]; // A = base
        for (int k = 0; k < NUM_DIGITS; k++)
          g_B[k] = g_block[k]; // B = block

        mult_mod_operation(g_A, g_B, g_block); // Result goes back into g_block

        // --- Original Task: task_mult_block_get_result ---
        // Logic merged above (updating g_block).
        // Check if this was the last step (e==0) handled after loop or by check
      }

      if (e > 0) {
        // --- Original Task: task_square_base ---
        // base = (base * base) % N
        for (int k = 0; k < NUM_DIGITS; k++)
          g_A[k] = g_base[k];
        for (int k = 0; k < NUM_DIGITS; k++)
          g_B[k] = g_base[k];

        mult_mod_operation(g_A, g_B, g_base); // Result updates g_base
      }
    }

    // --- Original Task: task_mult_block_get_result (Final save) ---
    // Exponentiation done for this block. Save g_block to cyphertext.
    if (g_cyphertext_len + NUM_DIGITS <= CYPHERTEXT_SIZE) {
      for (i = 0; i < NUM_DIGITS; ++i) {
        g_cyphertext[g_cyphertext_len++] = g_block[i];
      }
    } else {
      DEBUG_PRINTF("WARN: block dropped: cyphertext overflow\r\n");
    }

    PORT_LED_1 ^= (1 << PIN_LED_1); // Toggle LED to show progress
  }

  // --- Original Task: task_print_cyphertext ---
  DEBUG_PRINTF("Cyphertext:\r\n");
  char line[PRINT_HEX_ASCII_COLS];
  int j = 0;

  for (int i = 0; i < g_cyphertext_len; ++i) {
    digit_t c = g_cyphertext[i];
    DEBUG_PRINTF("%02x ", c);
    line[j++] = c;
    if ((i + 1) % PRINT_HEX_ASCII_COLS == 0) {
      DEBUG_PRINTF(" ");
      for (int k = 0; k < PRINT_HEX_ASCII_COLS; ++k) {
        char ch = line[k];
        if (!(32 <= ch && ch <= 127))
          ch = '.';
        DEBUG_PRINTF("%c", ch);
      }
      j = 0;
      DEBUG_PRINTF("\r\n");
    }
  }
  DEBUG_PRINTF("\r\n");

  // End of program
  while (1)
    ;
  return 0;
}