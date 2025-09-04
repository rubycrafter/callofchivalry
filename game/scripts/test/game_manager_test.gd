extends Node

const GameManager = preload("res://game/scripts/game_manager/game_manager.gd")
const ForestLocation = preload("res://game/scripts/locations/forest_location.gd")

var test_results = {
	"total": 0,
	"passed": 0,
	"failed": 0,
	"details": []
}

func run_tests() -> void:
	print("=== Game Manager Test ===")
	print("")
	
	test_initial_state()
	test_start_new_game()
	test_reset_game()
	test_enter_location()
	test_challenge_execution()
	test_action_effects()
	test_save_load()
	test_game_stats()
	
	print("")
	print("=== Test Results: %d/%d passed ===" % [test_results.passed, test_results.total])

func test_initial_state() -> void:
	print("--- Initial State Test ---")
	var game_manager = GameManager.new()
	
	assert_equals(game_manager.current_state, GameManager.State.MENU, "Should start in MENU state")
	assert_equals(game_manager.knight != null, true, "Should have knight instance")
	assert_equals(game_manager.inventory != null, true, "Should have inventory instance")
	assert_equals(game_manager.current_location, null, "Should have no current location")
	assert_equals(game_manager.current_challenge, null, "Should have no current challenge")

func test_start_new_game() -> void:
	print("--- Start New Game Test ---")
	var game_manager = GameManager.new()
	
	var signal_emitted = false
	game_manager.game_started.connect(func(): signal_emitted = true)
	
	game_manager.start_new_game()
	
	assert_equals(game_manager.current_state, GameManager.State.PREPARING, "Should be in PREPARING state")
	assert_equals(signal_emitted, true, "Should emit game_started signal")

func test_reset_game() -> void:
	print("--- Reset Game Test ---")
	var game_manager = GameManager.new()
	
	game_manager.start_new_game()
	game_manager.current_state = GameManager.State.IN_LOCATION
	game_manager.current_challenge_index = 5
	
	game_manager.reset_game()
	
	assert_equals(game_manager.current_state, GameManager.State.MENU, "Should reset to MENU state")
	assert_equals(game_manager.current_challenge_index, 0, "Should reset challenge index")
	assert_equals(game_manager.current_location, null, "Should clear current location")
	assert_equals(game_manager.knight.health, game_manager.knight.max_health, "Should reset knight health")

func test_enter_location() -> void:
	print("--- Enter Location Test ---")
	var game_manager = GameManager.new()
	var forest = ForestLocation.new()
	
	var signal_emitted = false
	var emitted_location = null
	game_manager.location_entered.connect(func(loc): 
		signal_emitted = true
		emitted_location = loc
	)
	
	game_manager.enter_location(forest)
	
	assert_equals(game_manager.current_state, GameManager.State.IN_LOCATION, "Should be in IN_LOCATION state")
	assert_equals(game_manager.current_location, forest, "Should set current location")
	assert_equals(signal_emitted, true, "Should emit location_entered signal")
	assert_equals(emitted_location, forest, "Should emit correct location")

func test_challenge_execution() -> void:
	print("--- Challenge Execution Test ---")
	var game_manager = GameManager.new()
	var forest = ForestLocation.new()
	
	game_manager.enter_location(forest)
	
	var signal_emitted = false
	game_manager.challenge_started.connect(func(_challenge): signal_emitted = true)
	
	game_manager.start_next_challenge()
	
	assert_equals(game_manager.current_challenge != null, true, "Should have current challenge")
	assert_equals(signal_emitted, true, "Should emit challenge_started signal")

func test_action_effects() -> void:
	print("--- Action Effects Test ---")
	var game_manager = GameManager.new()
	
	# Test coin spending
	var initial_coins = game_manager.knight.coins
	game_manager.knight.add_coins(10)
	
	var action = Challenge.ChallengeAction.new()
	action.type = Challenge.ActionType.SPEND_COINS
	action.coins_required = 5
	action.reward_coins = 2
	
	var success = game_manager._apply_action_effects(action)
	
	assert_equals(success, true, "Should successfully apply coin action")
	assert_equals(game_manager.knight.coins, initial_coins + 10 - 5 + 2, "Should correctly update coins")
	
	# Test damage action
	var initial_health = game_manager.knight.health
	
	var damage_action = Challenge.ChallengeAction.new()
	damage_action.type = Challenge.ActionType.TAKE_DAMAGE
	damage_action.damage_taken = 1
	
	success = game_manager._apply_action_effects(damage_action)
	
	assert_equals(success, true, "Should successfully apply damage action")
	assert_equals(game_manager.knight.health, initial_health - 1, "Should correctly apply damage")

func test_save_load() -> void:
	print("--- Save/Load Test ---")
	var game_manager = GameManager.new()
	
	game_manager.start_new_game()
	game_manager.knight.take_damage(1)
	game_manager.knight.add_coins(10)
	game_manager.current_challenge_index = 3
	
	var save_data = game_manager.save_game()
	
	assert_equals(save_data.has("version"), true, "Save data should have version")
	assert_equals(save_data.has("state"), true, "Save data should have state")
	assert_equals(save_data.has("knight"), true, "Save data should have knight data")
	assert_equals(save_data.has("inventory"), true, "Save data should have inventory data")
	
	var new_manager = GameManager.new()
	var loaded = new_manager.load_game(save_data)
	
	assert_equals(loaded, true, "Should successfully load save data")
	assert_equals(new_manager.current_state, game_manager.current_state, "Should restore state")
	assert_equals(new_manager.knight.health, game_manager.knight.health, "Should restore knight health")
	assert_equals(new_manager.knight.coins, game_manager.knight.coins, "Should restore knight coins")
	assert_equals(new_manager.current_challenge_index, 3, "Should restore challenge index")

func test_game_stats() -> void:
	print("--- Game Stats Test ---")
	var game_manager = GameManager.new()
	
	game_manager.knight.take_damage(1)
	game_manager.knight.add_coins(5)
	
	var stats = game_manager.get_game_stats()
	
	assert_equals(stats.has("knight_health"), true, "Stats should have knight health")
	assert_equals(stats.has("knight_coins"), true, "Stats should have knight coins")
	assert_equals(stats.has("inventory_items"), true, "Stats should have inventory count")
	assert_equals(stats["knight_health"], game_manager.knight.health, "Stats should reflect current health")
	assert_equals(stats["knight_coins"], game_manager.knight.coins, "Stats should reflect current coins")

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