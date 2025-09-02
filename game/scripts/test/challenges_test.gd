extends Node

const Challenge = preload("res://game/scripts/challenges/challenge.gd")
const ChallengeOption = preload("res://game/scripts/challenges/challenge_option.gd")

var test_results = []
var total_tests = 0
var passed_tests = 0

func run_tests():
	print("Starting Challenge System Tests...")
	
	test_challenge_option_requirements()
	test_challenge_option_consequences()
	test_challenge_option_formatting()
	test_challenge_resources()
	test_challenge_selection()
	
	return get_results()

func test_challenge_option_requirements():
	print("  Testing ChallengeOption requirements...")
	var option = ChallengeOption.new()
	
	# Test coin requirement
	option.coins_required = 5
	var knight_state = {"coins": 3, "health": 3, "has_horse": true, "inventory": []}
	assert_equals(option.can_select(knight_state), false, "Should not select with insufficient coins")
	
	knight_state["coins"] = 5
	assert_equals(option.can_select(knight_state), true, "Should select with sufficient coins")
	
	# Test item requirement
	option.coins_required = 0
	option.item_required = "Меч"
	knight_state["inventory"] = []
	assert_equals(option.can_select(knight_state), false, "Should not select without required item")
	
	knight_state["inventory"] = ["Меч"]
	assert_equals(option.can_select(knight_state), true, "Should select with required item")
	
	# Test horse requirement
	option.item_required = ""
	option.horse_required = true
	knight_state["has_horse"] = false
	assert_equals(option.can_select(knight_state), false, "Should not select without horse")
	
	knight_state["has_horse"] = true
	assert_equals(option.can_select(knight_state), true, "Should select with horse")

func test_challenge_option_consequences():
	print("  Testing ChallengeOption consequences...")
	var option = ChallengeOption.new()
	option.coins_change = -3
	option.health_change = -1
	option.item_consumed = "Меч"
	option.reward_coins = 5
	option.reward_item = "Провизия"
	
	var knight_state = {
		"coins": 10,
		"health": 3,
		"has_horse": true,
		"inventory": ["Меч", "Щит"]
	}
	
	var new_state = option.apply_consequences(knight_state)
	
	assert_equals(new_state["coins"], 12, "Coins should be 10 - 3 + 5 = 12")
	assert_equals(new_state["health"], 2, "Health should be 3 - 1 = 2")
	assert_equals(new_state["inventory"].has("Меч"), false, "Меч should be consumed")
	assert_equals(new_state["inventory"].has("Провизия"), true, "Провизия should be added")
	assert_equals(new_state["inventory"].has("Щит"), true, "Щит should remain")

func test_challenge_option_formatting():
	print("  Testing ChallengeOption text formatting...")
	var option = ChallengeOption.new()
	option.text = "Откупиться"
	option.coins_required = 5
	
	var formatted = option.get_formatted_text()
	assert_equals(formatted, "Откупиться [-5 монет]", "Should format coin requirement")
	
	option.coins_required = 0
	option.health_change = -2
	option.text = "Сражаться"
	formatted = option.get_formatted_text()
	assert_equals(formatted, "Сражаться [-2 здоровья]", "Should format health cost")
	
	option.health_change = 0
	option.item_required = "Меч"
	option.text = "Использовать оружие"
	formatted = option.get_formatted_text()
	assert_equals(formatted, "Использовать оружие [Требуется: Меч]", "Should format item requirement")

func test_challenge_resources():
	print("  Testing Challenge resource loading...")
	
	# Test forest bandits challenge
	var bandits = load("res://game/resources/challenges/forest/bandits.tres")
	assert_not_null(bandits, "Forest bandits challenge should load")
	assert_equals(bandits.title, "Встреча с бандитами", "Bandits title should be correct")
	assert_equals(bandits.difficulty, 3, "Bandits difficulty should be 3")
	assert_equals(bandits.options.size(), 3, "Bandits should have 3 options")
	
	# Test bridge challenge
	var bridge = load("res://game/resources/challenges/forest/bridge.tres")
	assert_not_null(bridge, "Forest bridge challenge should load")
	assert_equals(bridge.title, "Разрушенный мост", "Bridge title should be correct")
	assert_equals(bridge.difficulty, 2, "Bridge difficulty should be 2")
	
	# Test steppe nomads challenge
	var nomads = load("res://game/resources/challenges/steppe/nomads.tres")
	assert_not_null(nomads, "Steppe nomads challenge should load")
	assert_equals(nomads.title, "Встреча с кочевниками", "Nomads title should be correct")
	
	# Test tundra blizzard challenge
	var blizzard = load("res://game/resources/challenges/tundra/blizzard.tres")
	assert_not_null(blizzard, "Tundra blizzard challenge should load")
	assert_equals(blizzard.title, "Снежная метель", "Blizzard title should be correct")

func test_challenge_selection():
	print("  Testing Challenge selection logic...")
	var challenge = Challenge.new()
	challenge.title = "Test Challenge"
	challenge.difficulty = 2
	
	var option1 = ChallengeOption.new()
	option1.text = "Option 1"
	option1.coins_required = 5
	
	var option2 = ChallengeOption.new()
	option2.text = "Option 2"
	option2.item_required = "Меч"
	
	var options_array: Array[ChallengeOption] = []
	options_array.append(option1)
	options_array.append(option2)
	challenge.options = options_array
	
	# Test with insufficient resources
	var poor_knight = {"coins": 3, "health": 3, "inventory": [], "has_horse": false}
	var available = challenge.get_available_options(poor_knight)
	assert_equals(available.size(), 0, "Poor knight should have no available options")
	
	# Test with sufficient coins
	var rich_knight = {"coins": 10, "health": 3, "inventory": [], "has_horse": false}
	available = challenge.get_available_options(rich_knight)
	assert_equals(available.size(), 1, "Rich knight should have 1 option (coins)")
	assert_equals(available[0], option1, "Available option should be coin option")
	
	# Test with item
	var armed_knight = {"coins": 0, "health": 3, "inventory": ["Меч"], "has_horse": false}
	available = challenge.get_available_options(armed_knight)
	assert_equals(available.size(), 1, "Armed knight should have 1 option (sword)")
	assert_equals(available[0], option2, "Available option should be sword option")

func assert_equals(actual, expected, message):
	total_tests += 1
	if actual == expected:
		passed_tests += 1
		test_results.append({"test": message, "passed": true})
	else:
		print("    FAILED: " + message + " (expected: " + str(expected) + ", got: " + str(actual) + ")")
		test_results.append({"test": message, "passed": false, "expected": expected, "actual": actual})

func assert_not_null(value, message):
	total_tests += 1
	if value != null:
		passed_tests += 1
		test_results.append({"test": message, "passed": true})
	else:
		print("    FAILED: " + message + " (value is null)")
		test_results.append({"test": message, "passed": false})

func get_results():
	return {
		"total": total_tests,
		"passed": passed_tests,
		"failed": total_tests - passed_tests,
		"details": test_results
	}