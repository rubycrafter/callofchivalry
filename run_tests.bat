@echo off
echo Running Godot tests...
godot --headless --script res://run_tests.gd
exit /b %ERRORLEVEL%