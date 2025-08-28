extends Node

const Knight = preload("res://game/scripts/knight/knight.gd")
const Challenge = preload("res://game/scripts/locations/challenge.gd")
const Location = preload("res://game/scripts/locations/location.gd")

var test_results = {
	"total": 0,
	"passed": 0,
	"failed": 0,
	"details": []
}

func run_tests() -> void:
	print("=== Location System Test ===")
	print("")
	
	test_challenge_action_availability()
	test_challenge_action_execution()
	test_location_challenge_selection()
	test_location_progression()
	
	print("")
	print("=== Test Results: %d/%d passed ===" % [test_results.passed, test_results.total])

func test_challenge_action_availability() -> void:
	print("--- Challenge Action Availability Test ---")
	
	var knight = Knight.new()
	var action = Challenge.ChallengeAction.new()
	
	action.type = Challenge.ActionType.SPEND_COINS
	action.coins_required = 3
	assert_equals(action.is_available(knight), true, "Should afford 3 coins with 5 coins")
	
	action.coins_required = 10
	assert_equals(action.is_available(knight), false, "Should not afford 10 coins with 5 coins")
	
	action.type = Challenge.ActionType.ESCAPE_ON_HORSE
	assert_equals(action.is_available(knight), true, "Should have horse initially")
	
	knight.lose_horse()
	assert_equals(action.is_available(knight), false, "Should not have horse after losing it")
	
	action.type = Challenge.ActionType.TAKE_DAMAGE
	action.damage_taken = 2
	assert_equals(action.is_available(knight), true, "Should survive 2 damage with 3 health")
	
	action.damage_taken = 4
	assert_equals(action.is_available(knight), false, "Should not survive 4 damage with 3 health")

func test_challenge_action_execution() -> void:
	print("--- Challenge Action Execution Test ---")
	
	var knight = Knight.new()
	var action = Challenge.ChallengeAction.new()
	
	action.type = Challenge.ActionType.SPEND_COINS
	action.coins_required = 3
	action.success_message = "Paid coins"
	action.reward_coins = 2
	
	var result = action.execute(knight)
	assert_equals(result["success"], true, "Action should succeed")
	assert_equals(knight.coins, 4, "Should have 4 coins (5 - 3 + 2)")
	
	action = Challenge.ChallengeAction.new()
	action.type = Challenge.ActionType.TAKE_DAMAGE
	action.damage_taken = 1
	action.success_message = "Took damage"
	
	result = action.execute(knight)
	assert_equals(result["success"], true, "Damage action should succeed")
	assert_equals(knight.current_health, 2, "Should have 2 health after 1 damage")

func test_location_challenge_selection() -> void:
	print("--- Location Challenge Selection Test ---")
	
	var location = Location.new()
	location.name = "Test Location"
	location.min_challenges = 1
	location.max_challenges = 3
	
	for i in range(5):
		var challenge = Challenge.new()
		challenge.title = "Challenge %d" % i
		challenge.difficulty = randi_range(1, 3)
		location.challenges.append(challenge)
	
	location._select_challenges()
	
	assert_equals(location.selected_challenges.size() >= 1, true, "Should select at least 1 challenge")
	assert_equals(location.selected_challenges.size() <= 3, true, "Should select at most 3 challenges")
	
	var total_difficulty = 0
	for challenge in location.selected_challenges:
		total_difficulty += challenge.difficulty
	
	print("  Selected %d challenges with total difficulty %d" % [location.selected_challenges.size(), total_difficulty])

func test_location_progression() -> void:
	print("--- Location Progression Test ---")
	
	var location = Location.new()
	location.name = "Test Location"
	
	for i in range(3):
		var challenge = Challenge.new()
		challenge.title = "Challenge %d" % i
		challenge.difficulty = 1
		location.challenges.append(challenge)
	
	location.min_challenges = 2
	location.max_challenges = 2
	
	location.enter_location()
	assert_equals(location.selected_challenges.size(), 2, "Should select 2 challenges")
	assert_equals(location.current_challenge_index, 0, "Should start at index 0")
	assert_equals(location.is_completed, false, "Location should not be completed initially")
	
	var current = location.get_current_challenge()
	assert_equals(current != null, true, "Should have current challenge")
	
	location.complete_current_challenge(true)
	assert_equals(location.current_challenge_index, 1, "Should advance to index 1")
	assert_equals(location.get_progress(), 0.5, "Progress should be 50%")
	
	location.complete_current_challenge(true)
	assert_equals(location.is_completed, true, "Location should be completed")
	assert_equals(location.get_progress(), 1.0, "Progress should be 100%")


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