#include "setup.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// --- Hardware & Configuration ---

// LED Definitions for MSP430FR5994 LaunchPad
#define LED1_PIN BIT0 // P1.0 (Red)
#define LED2_PIN BIT1 // P1.1 (Green)

#define SEC_TO_CYCLES CLOCK_HZ

// Algorithm Constants
#define NUM_WARMUP_SAMPLES 3
#define ACCEL_WINDOW_SIZE 3
#define MODEL_SIZE 16
#define SAMPLE_NOISE_FLOOR 10
#define SAMPLES_TO_COLLECT 64 // Reduced for faster demo loop

// --- Data Types ---

// struct from libadxl362
typedef struct {
  int8_t x;
  int8_t y;
  int8_t z;
} threeAxis_t_8;

typedef threeAxis_t_8 accelReading;
typedef accelReading accelWindow[ACCEL_WINDOW_SIZE];

typedef struct {
  unsigned meanmag;
  unsigned stddevmag;
} features_t;

typedef enum {
  CLASS_STATIONARY,
  CLASS_MOVING,
} class_t;

typedef struct {
  features_t stationary[MODEL_SIZE];
  features_t moving[MODEL_SIZE];
} model_t;

typedef struct {
  unsigned totalCount;
  unsigned movingCount;
  unsigned stationaryCount;
} stats_t;

// --- Helper Functions (UART & Math) ---

// Integer Square Root (Replaces libmspmath)
unsigned sqrt16(unsigned long n) {
  unsigned long c = 0x8000;
  unsigned long g = 0x8000;
  for (;;) {
    if (g * g > n)
      g ^= c;
    c >>= 1;
    if (c == 0)
      return g;
    g |= c;
  }
}

void delay(uint32_t cycles) {
  while (cycles--)
    __delay_cycles(1);
}

// --- Sensor Abstraction (Mock Data) ---

// If you have a real ADXL362, you would replace these with actual driver calls.
// For now, we generate fake data to prove the logic works.

static int mock_scenario = 0; // 0=Stationary, 1=Moving

void ACCEL_init() {
  // Real sensor init would go here
}

void accel_sample(accelReading *sample) {
  // Generate synthetic data based on current scenario
  if (mock_scenario == 0) {
    // Stationary: Small noise near 0
    sample->x = (rand() % 4) - 2;
    sample->y = (rand() % 4) - 2;
    sample->z = (rand() % 4) - 2;
  } else {
    // Moving: Large spikes
    sample->x = (rand() % 60) - 30;
    sample->y = (rand() % 60) - 30;
    sample->z = (rand() % 60) - 30;
  }
}

// --- Core Algorithm Logic ---

void acquire_window(accelWindow window) {
  accelReading sample;
  unsigned samplesInWindow = 0;

  while (samplesInWindow < ACCEL_WINDOW_SIZE) {
    accel_sample(&sample);
    window[samplesInWindow++] = sample;
  }
}

void transform(accelWindow window) {
  unsigned i = 0;
  for (i = 0; i < ACCEL_WINDOW_SIZE; i++) {
    accelReading *sample = &window[i];

    // Simple High-pass / Noise gate filter
    if (abs(sample->x) < SAMPLE_NOISE_FLOOR)
      sample->x = 0;
    if (abs(sample->y) < SAMPLE_NOISE_FLOOR)
      sample->y = 0;
    if (abs(sample->z) < SAMPLE_NOISE_FLOOR)
      sample->z = 0;
  }
}

void featurize(features_t *features, accelWindow aWin) {
  long mean_x = 0, mean_y = 0, mean_z = 0;
  long std_x = 0, std_y = 0, std_z = 0;
  int i;

  // Calculate Mean
  for (i = 0; i < ACCEL_WINDOW_SIZE; i++) {
    mean_x += aWin[i].x;
    mean_y += aWin[i].y;
    mean_z += aWin[i].z;
  }
  mean_x /= ACCEL_WINDOW_SIZE;
  mean_y /= ACCEL_WINDOW_SIZE;
  mean_z /= ACCEL_WINDOW_SIZE;

  // Calculate Deviation
  for (i = 0; i < ACCEL_WINDOW_SIZE; i++) {
    std_x += abs(aWin[i].x - mean_x);
    std_y += abs(aWin[i].y - mean_y);
    std_z += abs(aWin[i].z - mean_z);
  }
  std_x /= ACCEL_WINDOW_SIZE;
  std_y /= ACCEL_WINDOW_SIZE;
  std_z /= ACCEL_WINDOW_SIZE;

  unsigned meanmag = mean_x * mean_x + mean_y * mean_y + mean_z * mean_z;
  unsigned stddevmag = std_x * std_x + std_y * std_y + std_z * std_z;

  features->meanmag = sqrt16(meanmag);
  features->stddevmag = sqrt16(stddevmag);
}

class_t classify(features_t *features, model_t *model) {
  int move_less_error = 0;
  int stat_less_error = 0;
  features_t *model_features;
  int i;

  // Nearest Centroid-ish classification
  for (i = 0; i < MODEL_SIZE; ++i) {
    model_features = &model->stationary[i];
    long stat_mean_err =
        abs((long)model_features->meanmag - (long)features->meanmag);
    long stat_sd_err =
        abs((long)model_features->stddevmag - (long)features->stddevmag);

    model_features = &model->moving[i];
    long move_mean_err =
        abs((long)model_features->meanmag - (long)features->meanmag);
    long move_sd_err =
        abs((long)model_features->stddevmag - (long)features->stddevmag);

    if (move_mean_err < stat_mean_err)
      move_less_error++;
    else
      stat_less_error++;

    if (move_sd_err < stat_sd_err)
      move_less_error++;
    else
      stat_less_error++;
  }

  return (move_less_error > stat_less_error) ? CLASS_MOVING : CLASS_STATIONARY;
}

void warmup_sensor() {
  unsigned discarded = 0;
  accelReading sample;
  printf("Warmup...\n");
  while (discarded++ < NUM_WARMUP_SAMPLES) {
    accel_sample(&sample);
  }
}

void train(features_t *classModel) {
  accelWindow sampleWindow;
  features_t features;
  unsigned i;

  warmup_sensor();

  for (i = 0; i < MODEL_SIZE; ++i) {
    acquire_window(sampleWindow);
    transform(sampleWindow);
    featurize(&features, sampleWindow);
    classModel[i] = features;

    // Blink LED1 during training
    P1OUT ^= LED1_PIN;
    delay(SEC_TO_CYCLES / 20);
  }
  P1OUT &= ~LED1_PIN; // LED off
  printf("Train done. MeanMag: %u StdMag: %u\n", features.meanmag,
         features.stddevmag);
}

void recognize_loop(model_t *model) {
  stats_t stats = {0};
  accelWindow sampleWindow;
  features_t features;
  class_t class;
  unsigned i;

  printf("Starting Recognition Loop...\n");

  for (i = 0; i < SAMPLES_TO_COLLECT; ++i) {
    // Toggle Mock Scenario halfway through to prove it works
    if (i == SAMPLES_TO_COLLECT / 2) {
      printf("\n--- SWITCHING MOCK MOVEMENT ---\n");
      mock_scenario = !mock_scenario;
    }

    acquire_window(sampleWindow);
    transform(sampleWindow);
    featurize(&features, sampleWindow);
    class = classify(&features, model);

    stats.totalCount++;
    if (class == CLASS_MOVING) {
      stats.movingCount++;
      P1OUT |= LED1_PIN; // Red for Moving
      P1OUT &= ~LED2_PIN;
    } else {
      stats.stationaryCount++;
      P1OUT |= LED2_PIN; // Green for Stationary
      P1OUT &= ~LED1_PIN;
    }

    // Brief delay so we can see the LEDs toggle
    delay(SEC_TO_CYCLES / 10);
  }

  printf("\nStats: Stationary: %u | Moving: %u | Total: %u\n",
         stats.stationaryCount, stats.movingCount, stats.totalCount);
}

// --- Main ---

// Global model storage (in RAM for this simple version)
model_t global_model;

int main() {
  initialize();
  // LED Setup
  P1DIR |= (LED1_PIN | LED2_PIN);
  P1OUT &= ~(LED1_PIN | LED2_PIN);

  ACCEL_init();

  __enable_interrupt();

  printf("\n\n--- Activity Recognition Demo ---\n");

  // 1. Train "Stationary"
  // We set mock_scenario to 0 (Stationary)
  printf("\n[Mode] Training Stationary Class...\n");
  mock_scenario = 0;
  train(global_model.stationary);
  delay(SEC_TO_CYCLES);

  // 2. Train "Moving"
  // We set mock_scenario to 1 (Moving)
  printf("\n[Mode] Training Moving Class...\n");
  mock_scenario = 1;
  train(global_model.moving);
  delay(SEC_TO_CYCLES);

  // 3. Recognize
  // We reset mock to 0, but recognize_loop will flip it halfway
  printf("\n[Mode] Recognition...\n");
  mock_scenario = 0;

  while (1) {
    recognize_loop(&global_model);
    delay(SEC_TO_CYCLES);
  }

  return 0;
}