#!/bin/bash

# Test script for Call of Chivalry
# Works both locally and in CI

echo "========================================="
echo "    CALL OF CHIVALRY TEST SUITE"
echo "========================================="
echo ""

# Find Godot executable
if [ -n "$GODOT_PATH" ]; then
    GODOT_EXEC="$GODOT_PATH"
elif command -v godot &> /dev/null; then
    GODOT_EXEC="godot"
else
    echo "Error: Godot not found. Please set GODOT_PATH environment variable."
    exit 1
fi

echo "Using Godot: $GODOT_EXEC"
echo ""

# Run tests
"$GODOT_EXEC" --headless --path . game/scenes/test/test_runner.tscn

# Capture exit code
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Test suite completed successfully!"
else
    echo ""
    echo "❌ Test suite failed with exit code $EXIT_CODE"
fi

exit $EXIT_CODE