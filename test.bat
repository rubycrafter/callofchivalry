@echo off
echo =========================================
echo     CALL OF CHIVALRY TEST SUITE
echo =========================================
echo.

REM Find Godot executable
if defined GODOT_PATH (
    set GODOT_EXEC=%GODOT_PATH%
) else (
    where godot >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set GODOT_EXEC=godot
    ) else (
        echo Error: Godot not found. Please set GODOT_PATH environment variable.
        exit /b 1
    )
)

echo Using Godot: %GODOT_EXEC%
echo.

REM Run tests
"%GODOT_EXEC%" --headless --path . game/scenes/test/test_runner.tscn

REM Capture exit code
set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% EQU 0 (
    echo.
    echo [PASS] Test suite completed successfully!
) else (
    echo.
    echo [FAIL] Test suite failed with exit code %EXIT_CODE%
)

exit /b %EXIT_CODE%