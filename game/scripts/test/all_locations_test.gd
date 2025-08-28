extends Node

const Knight = preload("res://game/scripts/knight/knight.gd")
const ForestLocation = preload("res://game/scripts/locations/forest_location.gd")
const SteppeLocation = preload("res://game/scripts/locations/steppe_location.gd")
const TundraLocation = preload("res://game/scripts/locations/tundra_location.gd")
const SwampLocation = preload("res://game/scripts/locations/swamp_location.gd")
const DesertLocation = preload("res://game/scripts/locations/desert_location.gd")
const GlacierLocation = preload("res://game/scripts/locations/glacier_location.gd")
const MountainLocation = preload("res://game/scripts/locations/mountain_location.gd")
const VolcanoLocation = preload("res://game/scripts/locations/volcano_location.gd")
const CaveLocation = preload("res://game/scripts/locations/cave_location.gd")
const DragonLairLocation = preload("res://game/scripts/locations/dragon_lair_location.gd")

var test_results = {
	"total": 0,
	"passed": 0,
	"failed": 0,
	"details": []
}

func run_tests() -> void:
	print("=== All Locations Test ===")
	print("")
	
	test_forest_location()
	test_steppe_location()
	test_tundra_location()
	test_swamp_location()
	test_desert_location()
	test_glacier_location()
	test_mountain_location()
	test_volcano_location()
	test_cave_location()
	test_dragon_lair_location()
	
	print("")
	print("=== Test Results: %d/%d passed ===" % [test_results.passed, test_results.total])

func test_forest_location() -> void:
	print("--- Forest Location Test ---")
	var location = ForestLocation.new()
	assert_equals(location.name, "Лес", "Forest should be named 'Лес'")
	assert_equals(location.challenges.size(), 5, "Forest should have 5 challenges")
	test_location_basics(location)

func test_steppe_location() -> void:
	print("--- Steppe Location Test ---")
	var location = SteppeLocation.new()
	assert_equals(location.name, "Степь", "Steppe should be named 'Степь'")
	assert_equals(location.challenges.size(), 5, "Steppe should have 5 challenges")
	test_location_basics(location)

func test_tundra_location() -> void:
	print("--- Tundra Location Test ---")
	var location = TundraLocation.new()
	assert_equals(location.name, "Тундра", "Tundra should be named 'Тундра'")
	assert_equals(location.challenges.size(), 5, "Tundra should have 5 challenges")
	test_location_basics(location)

func test_swamp_location() -> void:
	print("--- Swamp Location Test ---")
	var location = SwampLocation.new()
	assert_equals(location.name, "Болото", "Swamp should be named 'Болото'")
	assert_equals(location.challenges.size(), 5, "Swamp should have 5 challenges")
	test_location_basics(location)

func test_desert_location() -> void:
	print("--- Desert Location Test ---")
	var location = DesertLocation.new()
	assert_equals(location.name, "Пустыня", "Desert should be named 'Пустыня'")
	assert_equals(location.challenges.size(), 5, "Desert should have 5 challenges")
	test_location_basics(location)

func test_glacier_location() -> void:
	print("--- Glacier Location Test ---")
	var location = GlacierLocation.new()
	assert_equals(location.name, "Ледник", "Glacier should be named 'Ледник'")
	assert_equals(location.challenges.size(), 5, "Glacier should have 5 challenges")
	test_location_basics(location)

func test_mountain_location() -> void:
	print("--- Mountain Location Test ---")
	var location = MountainLocation.new()
	assert_equals(location.name, "Гора", "Mountain should be named 'Гора'")
	assert_equals(location.challenges.size(), 5, "Mountain should have 5 challenges")
	test_location_basics(location)

func test_volcano_location() -> void:
	print("--- Volcano Location Test ---")
	var location = VolcanoLocation.new()
	assert_equals(location.name, "Вулкан", "Volcano should be named 'Вулкан'")
	assert_equals(location.challenges.size(), 5, "Volcano should have 5 challenges")
	test_location_basics(location)

func test_cave_location() -> void:
	print("--- Cave Location Test ---")
	var location = CaveLocation.new()
	assert_equals(location.name, "Пещера", "Cave should be named 'Пещера'")
	assert_equals(location.challenges.size(), 5, "Cave should have 5 challenges")
	test_location_basics(location)

func test_dragon_lair_location() -> void:
	print("--- Dragon Lair Location Test ---")
	var location = DragonLairLocation.new()
	assert_equals(location.name, "Логово дракона", "Dragon Lair should be named 'Логово дракона'")
	assert_equals(location.challenges.size(), 5, "Dragon Lair should have 5 challenges")
	assert_equals(location.min_challenges >= 3, true, "Dragon Lair should have min 3 challenges")
	test_location_basics(location)

func test_location_basics(location) -> void:
	location.enter_location()
	assert_equals(location.selected_challenges.size() >= location.min_challenges, true, 
		"Should select at least min_challenges")
	assert_equals(location.selected_challenges.size() <= location.max_challenges, true, 
		"Should select at most max_challenges")
	
	var knight = Knight.new()
	if location.selected_challenges.size() > 0:
		var challenge = location.selected_challenges[0]
		var available_actions = challenge.get_available_actions(knight)
		assert_equals(available_actions.size() > 0, true, "Challenge should have available actions")

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