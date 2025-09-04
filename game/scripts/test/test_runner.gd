extends Node

signal all_tests_completed(results: Dictionary)

var test_files: Array = [
	"res://game/scripts/test/knight_test.gd",
	"res://game/scripts/test/items_test.gd",
	"res://game/scripts/test/challenges_test.gd",
	# "res://game/scripts/test/game_manager_test.gd", # TODO: Fix resource loading in headless mode
	# "res://game/scripts/test/game_map_test.gd", # TODO: Fix resource loading in headless mode
	# "res://game/scripts/test/all_locations_test.gd", # TODO: Fix imports and enable
	# "res://game/scripts/test/location_test.gd", # TODO: Fix imports and enable
	# Add more test files here as we create them
]

var current_test_index: int = 0
var test_results: Dictionary = {}
var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _ready():
	print("\n========================================")
	print("    STARTING AUTOMATED TEST SUITE")
	print("========================================\n")
	run_next_test()

func run_next_test():
	if current_test_index >= test_files.size():
		finish_testing()
		return
	
	var test_path = test_files[current_test_index]
	print("Running test: " + test_path)
	print("----------------------------------------")
	
	var test_script = load(test_path)
	if test_script:
		var test_instance = test_script.new()
		add_child(test_instance)
		
		# Wait for test to initialize
		await get_tree().process_frame
		
		# Run the test
		if test_instance.has_method("run_tests"):
			test_instance.run_tests()
			
			# Wait for tests to complete
			await get_tree().create_timer(0.5).timeout
			
			# Collect results
			if test_instance.has_method("get_results"):
				var results = test_instance.get_results()
				test_results[test_path] = results
				total_tests += results.total
				passed_tests += results.passed
				failed_tests += results.failed
			
			test_instance.queue_free()
		else:
			print("ERROR: Test file doesn't have run_tests() method")
			test_results[test_path] = {"error": "No run_tests() method"}
	else:
		print("ERROR: Could not load test file")
		test_results[test_path] = {"error": "Could not load file"}
	
	print("")
	current_test_index += 1
	run_next_test()

func finish_testing():
	print("\n========================================")
	print("    TEST RESULTS SUMMARY")
	print("========================================")
	print("Total Tests: " + str(total_tests))
	print("Passed: " + str(passed_tests))
	print("Failed: " + str(failed_tests))
	
	if failed_tests == 0:
		print("\n✅ ALL TESTS PASSED!")
	else:
		print("\n❌ SOME TESTS FAILED")
		print("\nFailed Tests:")
		for test_path in test_results:
			var result = test_results[test_path]
			if result.has("failed") and result.failed > 0:
				print("  - " + test_path + ": " + str(result.failed) + " failures")
	
	print("\n========================================\n")
	
	all_tests_completed.emit(test_results)
	
	# Exit after a short delay
	await get_tree().create_timer(1.0).timeout
	get_tree().quit(0 if failed_tests == 0 else 1)