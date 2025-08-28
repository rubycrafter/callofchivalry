extends Node

const GameMap = preload("res://game/scripts/game_map/game_map.gd")

var test_results = {
	"total": 0,
	"passed": 0,
	"failed": 0,
	"details": []
}

func run_tests() -> void:
	print("=== Game Map Test ===")
	print("")
	
	# Check if GameMap can be loaded
	if not GameMap:
		print("ERROR: Failed to load GameMap script")
		return
	
	test_initial_state()
	test_initial_location_choices()
	test_start_journey()
	test_movement_rules()
	test_diagonal_movement()
	test_progress_tracking()
	test_final_location()
	test_complete_journey()
	test_reset_functionality()
	
	print("")
	print("=== Test Results: %d/%d passed ===" % [test_results.passed, test_results.total])

func test_initial_state() -> void:
	print("--- Initial State Test ---")
	var game_map = GameMap.new()
	
	assert_equals(game_map.current_row, GameMap.MapRow.ROW_1, "Should start at row 1")
	assert_equals(game_map.current_position, GameMap.LocationPosition.CENTER, "Should start at center position")
	assert_equals(game_map.visited_locations.size(), 0, "Should have no visited locations")
	assert_equals(game_map.completed_locations.size(), 0, "Should have no completed locations")
	assert_equals(game_map.can_start_journey(), true, "Should be able to start journey")

func test_initial_location_choices() -> void:
	print("--- Initial Location Choices Test ---")
	var game_map = GameMap.new()
	if not game_map.has_method("get_initial_location_choices"):
		print("  ✗ Method get_initial_location_choices not found")
		test_results.failed += 1
		test_results.total += 1
		return
	
	var choices = game_map.get_initial_location_choices()
	
	assert_equals(choices.size(), 3, "Should have 3 initial location choices")
	
	var location_names = []
	for location in choices:
		location_names.append(location.name)
	
	assert_equals("Лес" in location_names, true, "Forest should be available")
	assert_equals("Степь" in location_names, true, "Steppe should be available")
	assert_equals("Тундра" in location_names, true, "Tundra should be available")

func test_start_journey() -> void:
	print("--- Start Journey Test ---")
	var game_map = GameMap.new()
	
	var forest = game_map.get_initial_location_choices()[0]
	assert_equals(game_map.start_journey_from(forest), true, "Should be able to start from forest")
	assert_equals(game_map.visited_locations.size(), 1, "Should have 1 visited location")
	assert_equals(game_map.visited_locations[0], forest.name, "Forest should be marked as visited")
	assert_equals(game_map.current_position, GameMap.LocationPosition.LEFT, "Should be at left position after selecting forest")

func test_movement_rules() -> void:
	print("--- Movement Rules Test ---")
	var game_map = GameMap.new()
	
	var steppe = null
	for location in game_map.get_initial_location_choices():
		if location.name == "Степь":
			steppe = location
			break
	
	game_map.start_journey_from(steppe)
	var next_locations = game_map.get_available_next_locations()
	
	assert_equals(next_locations.size(), 3, "From center position should have 3 choices")
	
	var available_names = []
	for location in next_locations:
		available_names.append(location.name)
	
	assert_equals("Болото" in available_names, true, "Swamp should be available from center")
	assert_equals("Пустыня" in available_names, true, "Desert should be available from center")
	assert_equals("Ледник" in available_names, true, "Glacier should be available from center")

func test_diagonal_movement() -> void:
	print("--- Diagonal Movement Test ---")
	var game_map = GameMap.new()
	
	var forest = null
	for location in game_map.get_initial_location_choices():
		if location.name == "Лес":
			forest = location
			break
	
	game_map.start_journey_from(forest)
	assert_equals(game_map.current_position, GameMap.LocationPosition.LEFT, "Should be at left position")
	
	var next_locations = game_map.get_available_next_locations()
	assert_equals(next_locations.size(), 2, "From left position should have 2 choices")
	
	var available_names = []
	for location in next_locations:
		available_names.append(location.name)
	
	assert_equals("Болото" in available_names, true, "Swamp should be available from left")
	assert_equals("Пустыня" in available_names, true, "Desert should be available from left")
	assert_equals("Ледник" in available_names, false, "Glacier should NOT be available from left")

func test_progress_tracking() -> void:
	print("--- Progress Tracking Test ---")
	var game_map = GameMap.new()
	
	assert_equals(game_map.get_progress_percentage(), 0.0, "Initial progress should be 0%")
	
	var forest = null
	for location in game_map.get_initial_location_choices():
		if location.name == "Лес":
			forest = location
			break
	
	game_map.start_journey_from(forest)
	
	var swamp = null
	for location in game_map.get_available_next_locations():
		if location.name == "Болото":
			swamp = location
			break
	
	game_map.move_to_location(swamp)
	assert_equals(game_map.completed_locations.size(), 1, "Should have 1 completed location")
	assert_equals(game_map.get_progress_percentage(), 25.0, "Progress should be 25% after completing 1 location")

func test_final_location() -> void:
	print("--- Final Location Test ---")
	var game_map = GameMap.new()
	
	game_map.current_row = GameMap.MapRow.ROW_3
	game_map.current_position = GameMap.LocationPosition.CENTER
	
	var next_locations = game_map.get_available_next_locations()
	assert_equals(next_locations.size(), 1, "From row 3 should only have dragon lair available")
	assert_equals(next_locations[0].name, "Логово дракона", "Final location should be dragon lair")

func test_complete_journey() -> void:
	print("--- Complete Journey Test ---")
	var game_map = GameMap.new()
	
	var forest = null
	for location in game_map.get_initial_location_choices():
		if location.name == "Лес":
			forest = location
			break
	
	game_map.start_journey_from(forest)
	
	var swamp = null
	for location in game_map.get_available_next_locations():
		if location.name == "Болото":
			swamp = location
			break
	
	game_map.move_to_location(swamp)
	
	var mountain = null
	for location in game_map.get_available_next_locations():
		if location.name == "Гора":
			mountain = location
			break
	
	game_map.move_to_location(mountain)
	
	var dragon_lair = game_map.get_available_next_locations()[0]
	game_map.move_to_location(dragon_lair)
	
	assert_equals(game_map.is_journey_complete(), true, "Journey should be complete")
	assert_equals(game_map.current_row, GameMap.MapRow.FINAL, "Should be at final row")
	assert_equals(game_map.get_progress_percentage(), 100.0, "Progress should be 100%")

func test_reset_functionality() -> void:
	print("--- Reset Functionality Test ---")
	var game_map = GameMap.new()
	
	var forest = null
	for location in game_map.get_initial_location_choices():
		if location.name == "Лес":
			forest = location
			break
	
	game_map.start_journey_from(forest)
	game_map.visited_locations.append("Test Location")
	game_map.completed_locations.append("Test Completed")
	
	game_map.reset()
	
	assert_equals(game_map.current_row, GameMap.MapRow.ROW_1, "Should reset to row 1")
	assert_equals(game_map.current_position, GameMap.LocationPosition.CENTER, "Should reset to center")
	assert_equals(game_map.visited_locations.size(), 0, "Should clear visited locations")
	assert_equals(game_map.completed_locations.size(), 0, "Should clear completed locations")

func assert_equals(actual, expected, message: String) -> void:
	test_results.total += 1
	if actual == expected:
		test_results.passed += 1
		print("  ✓ %s" % message)
		test_results.details.append({"test": message, "passed": true})
	else:
		test_results.failed += 1
		print("  ✗ %s (expected: %s, got: %s)" % [message, expected, actual])
		test_results.details.append({"test": message, "passed": false, "expected": str(expected), "actual": str(actual)})

func get_results() -> Dictionary:
	return test_results