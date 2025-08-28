#!/usr/bin/env -S godot --headless --script
extends SceneTree

func _init():
	print("Starting test runner...")
	var test_runner = load("res://game/scenes/test/test_runner.tscn").instantiate()
	root.add_child(test_runner)
	
	# Wait for tests to complete
	await test_runner.all_tests_completed
	
	# Get results
	var results = test_runner.test_results
	var exit_code = 0 if test_runner.failed_tests == 0 else 1
	
	quit(exit_code)