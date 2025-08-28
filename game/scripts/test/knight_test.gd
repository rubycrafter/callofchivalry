extends Node

const Knight = preload("res://game/scripts/knight/knight.gd")
var knight
var test_results = {"total": 0, "passed": 0, "failed": 0, "details": []}

func _ready():
	print("=== Knight Test Scene ===")
	
	knight = Knight.new()
	add_child(knight)
	
	knight.health_changed.connect(_on_health_changed)
	knight.coins_changed.connect(_on_coins_changed)
	knight.died.connect(_on_knight_died)
	knight.horse_status_changed.connect(_on_horse_status_changed)

func run_tests():
	test_results = {"total": 0, "passed": 0, "failed": 0, "details": []}
	
	print("\n--- Initial State ---")
	assert_equals(knight.current_health, Knight.MAX_HEALTH, "Initial health should be MAX_HEALTH")
	assert_equals(knight.coins, Knight.STARTING_COINS, "Initial coins should be STARTING_COINS")
	assert_equals(knight.has_horse, true, "Should start with a horse")
	
	print("\n--- Health System Test ---")
	knight.take_damage(1)
	assert_equals(knight.current_health, 2, "Health should be 2 after 1 damage")
	
	knight.heal(1)
	assert_equals(knight.current_health, 3, "Health should be 3 after healing")
	
	knight.take_damage(3)
	assert_equals(knight.current_health, 0, "Health should be 0 after lethal damage")
	assert_equals(knight.is_alive(), false, "Knight should be dead")
	
	print("\n--- Reset Test ---")
	knight.reset()
	assert_equals(knight.current_health, Knight.MAX_HEALTH, "Health should be restored after reset")
	assert_equals(knight.coins, Knight.STARTING_COINS, "Coins should be restored after reset")
	assert_equals(knight.has_horse, true, "Horse should be restored after reset")
	assert_equals(knight.is_alive(), true, "Knight should be alive after reset")
	
	print("\n--- Coins System Test ---")
	assert_equals(knight.can_afford(3), true, "Should afford 3 coins with 5 coins")
	assert_equals(knight.can_afford(10), false, "Should not afford 10 coins with 5 coins")
	
	var spent = knight.spend_coins(3)
	assert_equals(spent, true, "Should successfully spend 3 coins")
	assert_equals(knight.coins, 2, "Should have 2 coins after spending 3")
	
	knight.add_coins(10)
	assert_equals(knight.coins, 12, "Should have 12 coins after adding 10")
	
	print("\n--- Horse System Test ---")
	assert_equals(knight.can_escape_on_horse(), true, "Should be able to escape with horse")
	knight.lose_horse()
	assert_equals(knight.has_horse, false, "Should not have horse after losing it")
	assert_equals(knight.can_escape_on_horse(), false, "Should not escape without horse")
	knight.gain_horse()
	assert_equals(knight.has_horse, true, "Should have horse after gaining it")
	
	print("\n--- Save/Load Test ---")
	knight.take_damage(1)
	knight.spend_coins(2)
	knight.lose_horse()
	
	var save_data = knight.save_data()
	assert_equals(save_data.health, 2, "Save data should have correct health")
	assert_equals(save_data.coins, 10, "Save data should have correct coins")
	assert_equals(save_data.has_horse, false, "Save data should have correct horse status")
	
	knight.reset()
	knight.load_data(save_data)
	assert_equals(knight.current_health, 2, "Loaded health should match saved")
	assert_equals(knight.coins, 10, "Loaded coins should match saved")
	assert_equals(knight.has_horse, false, "Loaded horse status should match saved")
	
	print("\n=== Test Results: %d/%d passed ===" % [test_results.passed, test_results.total])

func assert_equals(actual, expected, test_name: String):
	test_results.total += 1
	if actual == expected:
		test_results.passed += 1
		print("  ✓ %s" % test_name)
		test_results.details.append({"name": test_name, "passed": true})
	else:
		test_results.failed += 1
		print("  ✗ %s (expected %s, got %s)" % [test_name, str(expected), str(actual)])
		test_results.details.append({"name": test_name, "passed": false, "expected": expected, "actual": actual})

func get_results():
	return test_results

func _on_health_changed(new_health: int, max_health: int):
	print("  [Signal] Health changed: %d/%d" % [new_health, max_health])

func _on_coins_changed(new_coins: int):
	print("  [Signal] Coins changed: %d" % new_coins)

func _on_knight_died():
	print("  [Signal] Knight died!")

func _on_horse_status_changed(has_horse: bool):
	print("  [Signal] Horse status: %s" % has_horse)