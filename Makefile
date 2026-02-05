# Digital Rain - Matrix Terminal Animation Makefile
# Modern C Makefile based on gnaro project best practices

# ============================================================================
# Project Configuration
# ============================================================================

# Build configuration
DEBUG ?= 0          # 0=release, 1=debug
BUILD_TYPE ?= release

# Project structure
NAME := digital_rain
SRC_DIR := src
BUILD_DIR := build
INCLUDE_DIR := include
LIB_DIR := lib
TESTS_DIR := tests
BIN_DIR := bin

# Toolchain configuration
CC := gcc
LINTER := clang-tidy
FORMATTER := clang-format

# Compiler flags (C99 for compatibility with sp.h and modern C features)
CFLAGS := -std=c99 -Wall -Wextra -pedantic
CPPFLAGS := -I$(INCLUDE_DIR) -I$(LIB_DIR)
LDFLAGS := -lm

# Conditional compilation based on build type
ifeq ($(DEBUG),1)
    CFLAGS += -g -O0 -DDEBUG
else
    ifeq ($(BUILD_TYPE),release)
        CFLAGS += -O3 -DNDEBUG
    else ifeq ($(BUILD_TYPE),debug)
        CFLAGS += -g -O2 -DDEBUG
    else ifeq ($(BUILD_TYPE),profile)
        CFLAGS += -g -O2 -pg
        LDFLAGS += -pg
    endif
endif

# Add platform-specific flags
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    # Linux specific flags
    CFLAGS += -D_POSIX_C_SOURCE=200809L
endif
ifeq ($(UNAME_S),Darwin)
    # macOS specific flags
    CFLAGS += -D_DARWIN_C_SOURCE
endif

# Automatic file discovery
C_SOURCES := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(LIB_DIR)/**/*.c)
OBJECTS := $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES))

# ============================================================================
# Build Rules
# ============================================================================

# Default target
all: dir $(BIN_DIR)/$(NAME)

# Main executable
$(BIN_DIR)/$(NAME): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "Build complete: $(BIN_DIR)/$(NAME)"

# C source compilation
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# ============================================================================
# Development Tools
# ============================================================================

# Code quality checks
lint:
	@if command -v $(LINTER) >/dev/null 2>&1; then \
		echo "Running static analysis with $(LINTER)..."; \
		$(LINTER) $(SRC_DIR)/*.c $(INCLUDE_DIR)/*.h -- $(CFLAGS) $(CPPFLAGS); \
	else \
		echo "Warning: $(LINTER) not found. Install clang-tidy or adjust LINTER variable."; \
		echo "  Ubuntu/Debian: sudo apt install clang-tidy"; \
		echo "  macOS: brew install llvm"; \
	fi

format:
	@if command -v $(FORMATTER) >/dev/null 2>&1; then \
		echo "Formatting source code with $(FORMATTER)..."; \
		$(FORMATTER) -style=file -i $(SRC_DIR)/*.c $(INCLUDE_DIR)/*.h 2>/dev/null || \
		$(FORMATTER) -style=LLVM -i $(SRC_DIR)/*.c $(INCLUDE_DIR)/*.h; \
	else \
		echo "Warning: $(FORMATTER) not found. Install clang-format or adjust FORMATTER variable."; \
		echo "  Ubuntu/Debian: sudo apt install clang-format"; \
		echo "  macOS: brew install llvm"; \
	fi

# Testing
test: dir
	@echo "Test framework not configured. To add tests:"
	@echo "1. Create test files in $(TESTS_DIR)/"
	@echo "2. Update this target to compile and run tests"
	@echo "3. Consider using CUnit, Check, or another C test framework"

# Memory checking with valgrind
memcheck: $(BIN_DIR)/$(NAME)
	@if command -v valgrind >/dev/null 2>&1; then \
		echo "Running memory check with valgrind..."; \
		valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose ./$(BIN_DIR)/$(NAME); \
	else \
		echo "Warning: valgrind not found. Install it for memory checking."; \
		echo "  Ubuntu/Debian: sudo apt install valgrind"; \
		echo "  macOS: brew install valgrind"; \
	fi

# Run the program
run: $(BIN_DIR)/$(NAME)
	@echo "Running $(NAME)... (Press Ctrl+C to exit)"
	@./$(BIN_DIR)/$(NAME) || true

# Create necessary directories
dir:
	@mkdir -p $(BUILD_DIR) $(BIN_DIR)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)
	@echo "Cleaned build artifacts"

# Distclean: remove all generated files
distclean: clean
	rm -f *.log *.out compile_commands.json
	@echo "Distclean complete"

# Generate compile_commands.json for tooling
compile_commands.json: clean
	@if command -v bear >/dev/null 2>&1; then \
		bear -- make all; \
	else \
		echo "Warning: bear not found. Install it for compile_commands.json generation."; \
		echo "  Ubuntu/Debian: sudo apt install bear"; \
		echo "  macOS: brew install bear"; \
	fi

# Help target
help:
	@echo "Digital Rain - Matrix Terminal Animation"
	@echo "========================================="
	@echo "Available targets:"
	@echo "  all               - Build project (default)"
	@echo "  debug=1           - Build with debug configuration"
	@echo "  run               - Build and run the program"
	@echo "  lint              - Run static code analysis"
	@echo "  format            - Format source code"
	@echo "  test              - Run tests (configure first)"
	@echo "  memcheck          - Run memory checks with valgrind"
	@echo "  clean             - Remove build artifacts"
	@echo "  distclean         - Remove all generated files"
	@echo "  compile_commands.json - Generate compile_commands.json for tooling"
	@echo "  help              - Show this help message"
	@echo ""
	@echo "Build options:"
	@echo "  DEBUG=1           - Enable debug mode (adds -g -O0)"
	@echo "  BUILD_TYPE=debug  - Debug build with optimizations"
	@echo "  BUILD_TYPE=release - Release build with optimizations"
	@echo "  BUILD_TYPE=profile - Profile build with gprof support"

# ============================================================================
# Phony Targets Declaration
# ============================================================================

.PHONY: all lint format test memcheck run dir clean distclean help

# ============================================================================
# Project Information
# ============================================================================

# Digital Rain - Matrix Terminal Animation
# Based on Arduino DigitalRainAnimation.hpp by Eric Nam
# Modern C implementation using sp.h library
# 
# Files:
# - include/digital_rain.h - Header file with types and API declarations
# - src/digital_rain.c - Main implementation using sp.h library
# - src/main.c - Example usage and program entry point
#
# Dependencies:
# - sp.h library (in /usr/include/sp.h)
# - ANSI-compatible terminal
# - Standard C library with termios support (Linux/macOS)