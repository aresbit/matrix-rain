// main.c - Digital Rain terminal animation
// Test program for digital rain implementation

#include "digital_rain.h"
#include <stdio.h>

int main(void) {
    printf("Digital Rain - Matrix Terminal Animation\n");
    printf("Press Ctrl+C to exit\n\n");
    
    // Create digital rain instance
    digital_rain_t rain = digital_rain_create();
    
    // Customize settings (optional)
    rain.alphabet_only = false;
    rain.use_colors = true;
    rain.frame_delay_ms = 80;
    
    // Initialize with current terminal
    if (!digital_rain_init(&rain)) {
        fprintf(stderr, "Failed to initialize digital rain\n");
        return 1;
    }
    
    // Run animation
    digital_rain_run(&rain);
    
    // Cleanup
    digital_rain_destroy(&rain);
    
    return 0;
}