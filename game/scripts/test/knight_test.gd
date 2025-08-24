extends Node

const Knight = preload("res://game/scripts/knight/knight.gd")
var knight

func _ready():
	print("=== Knight Test Scene ===")
	
	knight = Knight.new()
	add_child(knight)
	
	knight.health_changed.connect(_on_health_changed)
	knight.coins_changed.connect(_on_coins_changed)
	knight.died.connect(_on_knight_died)
	knight.horse_status_changed.connect(_on_horse_status_changed)
	
	run_tests()

func run_tests():
	print("\n--- Initial State ---")
	print("Health: %d/%d" % [knight.current_health, knight.max_health])
	print("Coins: %d" % knight.coins)
	print("Has Horse: %s" % knight.has_horse)
	
	print("\n--- Health System Test ---")
	knight.take_damage(1)
	print("After 1 damage - Health: %d/%d" % [knight.current_health, knight.max_health])
	
	knight.heal(1)
	print("After 1 heal - Health: %d/%d" % [knight.current_health, knight.max_health])
	
	knight.take_damage(3)
	print("After 3 damage - Health: %d/%d (should trigger death)" % [knight.current_health, knight.max_health])
	
	print("\n--- Reset Test ---")
	knight.reset()
	print("After reset - Health: %d/%d, Coins: %d, Horse: %s" % [knight.current_health, knight.max_health, knight.coins, knight.has_horse])
	
	print("\n--- Coins System Test ---")
	print("Can afford 3 coins: %s" % knight.can_afford(3))
	print("Can afford 10 coins: %s" % knight.can_afford(10))
	
	if knight.spend_coins(3):
		print("Spent 3 coins successfully - Remaining: %d" % knight.coins)
	
	knight.add_coins(10)
	print("Added 10 coins - Total: %d" % knight.coins)
	
	print("\n--- Horse System Test ---")
	print("Can escape on horse: %s" % knight.can_escape_on_horse())
	knight.lose_horse()
	print("Lost horse - Can escape: %s" % knight.can_escape_on_horse())
	knight.gain_horse()
	print("Gained horse - Can escape: %s" % knight.can_escape_on_horse())
	
	print("\n--- Save/Load Test ---")
	knight.take_damage(1)
	knight.spend_coins(2)
	knight.lose_horse()
	
	var save_data = knight.save_data()
	print("Saved state - Health: %d, Coins: %d, Horse: %s" % [save_data.health, save_data.coins, save_data.has_horse])
	
	knight.reset()
	print("After reset - Health: %d, Coins: %d, Horse: %s" % [knight.current_health, knight.coins, knight.has_horse])
	
	knight.load_data(save_data)
	print("After load - Health: %d, Coins: %d, Horse: %s" % [knight.current_health, knight.coins, knight.has_horse])
	
	print("\n=== All Tests Complete ===")

func _on_health_changed(new_health: int, max_health: int):
	print("  [Signal] Health changed: %d/%d" % [new_health, max_health])

func _on_coins_changed(new_coins: int):
	print("  [Signal] Coins changed: %d" % new_coins)

func _on_knight_died():
	print("  [Signal] Knight died!")

func _on_horse_status_changed(has_horse: bool):
	print("  [Signal] Horse status: %s" % has_horse)