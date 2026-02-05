# Digital Rain - Matrix Terminal Animation

A modern C implementation of the "Matrix digital rain" effect for terminal/console, inspired by Arduino DigitalRainAnimation.hpp. Built using the sp.h library for a clean, modern C codebase.

## Features

- **Terminal-based animation**: Runs in any ANSI-compatible terminal
- **Color gradients**: Green tail with bright white head characters
- **Customizable settings**: Adjust speed, length, colors, and character sets
- **Responsive design**: Automatically adapts to terminal size
- **Clean exit**: Properly restores terminal state on exit
- **Modern C codebase**: Uses sp.h library for clean, maintainable code

## Requirements

- Linux/macOS/WSL terminal with ANSI escape code support
- GCC or Clang compiler
- sp.h library (typically in `/usr/include/sp.h`)

## Building

```bash
# Clone or navigate to the project directory
cd matrix-rain

# Build the project
make

# Build with debug information
make debug=1

# Build and run
make run
```

## Usage

```bash
# Run the animation
./bin/digital_rain

# Or use make run
make run

# Press Ctrl+C to exit
```

## Makefile Targets

```bash
make              # Build project (default)
make debug=1      # Build with debug symbols
make run          # Build and run the program
make lint         # Run static code analysis (requires clang-tidy)
make format       # Format source code (requires clang-format)
make memcheck     # Run memory checks (requires valgrind)
make clean        # Remove build artifacts
make help         # Show all available targets
```

## Project Structure

```
matrix-rain/
├── Makefile              # Build configuration
├── README.md             # This documentation
├── include/
│   └── digital_rain.h    # Header file with API
├── src/
│   ├── digital_rain.c    # Main implementation
│   └── main.c           # Program entry point
├── lib/                  # Third-party libraries (empty)
├── tests/               # Test files (to be added)
├── build/               # Object files (generated)
└── bin/                 # Executables (generated)
```

## How It Works

The animation creates multiple "rain columns" (one per terminal column):

1. **Column Initialization**: Each column gets random length, speed, and starting position
2. **Character Rendering**: Characters flow downward with brightness gradient (head is brightest)
3. **Color Gradients**: Head characters are bright white, tail characters fade from green to dark
4. **Column Recycling**: When a column reaches the bottom, it resets to the top with new random properties
5. **Terminal Control**: Uses ANSI escape codes for cursor positioning and colors

### Technical Details

- **Random Generation**: Uses xorshift64 PRNG for deterministic random sequences
- **Terminal Detection**: Automatically detects terminal size using ioctl/GetConsoleScreenBufferInfo
- **Signal Handling**: Properly handles SIGINT/SIGTERM for clean exit
- **Memory Management**: Uses sp.h allocator for clean memory handling

## Customization

You can customize the animation by modifying settings in `src/main.c`:

```c
digital_rain_t rain = digital_rain_create();

// Customize settings
rain.alphabet_only = false;   // Use full ASCII or only letters
rain.use_colors = true;       // Enable/disable colors  
rain.frame_delay_ms = 80;     // Animation speed (lower = faster)
rain.line_len_min = 3;        // Minimum rain column length
rain.line_len_max = 20;       // Maximum rain column length
rain.line_speed_min = 1;      // Minimum speed
rain.line_speed_max = 3;      // Maximum speed

// Color customization (ANSI escape codes)
rain.head_color = sp_str_lit(DR_ESC DR_COLOR_FG_BRIGHT_WHITE "m");
rain.text_color = sp_str_lit(DR_ESC DR_COLOR_FG_GREEN "m");
```

## Dependencies

### Required
- **sp.h**: Single-header C standard library replacement (included in `/usr/include/sp.h`)
- **ANSI Terminal**: Any terminal that supports ANSI escape codes

### Optional Development Tools
- **clang-tidy**: For static code analysis (`make lint`)
- **clang-format**: For code formatting (`make format`)
- **valgrind**: For memory checking (`make memcheck`)
- **bear**: For generating compile_commands.json

## Platform Support

- **Linux**: Fully supported (tested on WSL, Ubuntu)
- **macOS**: Should work with terminal apps (iTerm2, Terminal.app)
- **Windows**: Requires Windows Terminal or ConEmu with ANSI support

## Based On

- **Arduino DigitalRainAnimation.hpp** by Eric Nam (November 08, 2021)
- **sp.h** - Single-header C standard library replacement
- **ANSI Escape Codes** - For terminal control and colors
- **gnaro Makefile Template** - For modern build system best practices

## License

Public domain (same as the original Arduino implementation)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make lint` and `make format`
5. Submit a pull request

## Troubleshooting

### Terminal Issues
```bash
# If animation doesn't display properly
export TERM=xterm-256color

# For slow connections
make run BUILD_TYPE=release
```

### Build Issues
```bash
# If sp.h is not found
sudo apt install libsp-dev  # Or appropriate package

# For compilation errors
make clean && make debug=1
```

### Performance Issues
- Increase `frame_delay_ms` for slower animations
- Set `use_colors = false` for monochrome mode
- Reduce terminal size for better performance on slow connections