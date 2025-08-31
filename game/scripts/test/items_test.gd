extends Node

const WeaponItem = preload("res://game/scripts/items/weapon_item.gd")
const ArmorItem = preload("res://game/scripts/items/armor_item.gd")
const ConsumableItem = preload("res://game/scripts/items/consumable_item.gd")
const ToolItem = preload("res://game/scripts/items/tool_item.gd")

var test_results = []
var total_tests = 0
var passed_tests = 0

func run_tests():
	print("Starting Items Tests...")
	
	test_weapon_item()
	test_armor_item()
	test_consumable_item()
	test_tool_item()
	test_item_resources()
	
	return get_results()

func test_weapon_item():
	print("  Testing WeaponItem...")
	var weapon = WeaponItem.new()
	weapon.damage = 5
	weapon.durability = 2
	weapon.current_durability = 2
	
	var result = weapon.use()
	assert_equals(result.damage_dealt, 5, "Weapon damage should be 5")
	assert_equals(result.consumed, false, "Weapon should not be consumed on first use")
	
	result = weapon.use()
	assert_equals(result.consumed, true, "Weapon should be consumed after durability runs out")

func test_armor_item():
	print("  Testing ArmorItem...")
	var armor = ArmorItem.new()
	armor.defense = 3
	armor.durability = 2
	armor.current_durability = 2
	
	var absorbed = armor.absorb_damage(5)
	assert_equals(absorbed, 3, "Armor should absorb 3 damage")
	
	absorbed = armor.absorb_damage(5)
	assert_equals(absorbed, 0, "Broken armor should absorb 0 damage")

func test_consumable_item():
	print("  Testing ConsumableItem...")
	var consumable = ConsumableItem.new()
	consumable.effect_type = ConsumableItem.EffectType.HEAL
	consumable.effect_value = 2
	consumable.uses = 1
	consumable.current_uses = 1
	
	var result = consumable.use()
	assert_equals(result.effect_value, 2, "Consumable should have effect value of 2")
	assert_equals(result.consumed, true, "Single-use consumable should be consumed")

func test_tool_item():
	print("  Testing ToolItem...")
	var tool = ToolItem.new()
	tool.tool_type = "rope"
	tool.uses = 2
	tool.current_uses = 2
	
	assert_equals(tool.can_use_for("rope"), true, "Tool should be usable for rope")
	assert_equals(tool.can_use_for("torch"), false, "Tool should not be usable for torch")
	
	var result = tool.use()
	assert_equals(result.consumed, false, "Tool should not be consumed on first use")
	
	result = tool.use()
	assert_equals(result.consumed, true, "Tool should be consumed after last use")

func test_item_resources():
	print("  Testing Item Resources...")
	
	var sword = load("res://game/resources/items/sword.tres")
	assert_not_null(sword, "Sword resource should load")
	assert_equals(sword.name, "Меч", "Sword name should be correct")
	assert_equals(sword.damage, 5, "Sword damage should be 5")
	
	var shield = load("res://game/resources/items/shield.tres")
	assert_not_null(shield, "Shield resource should load")
	assert_equals(shield.name, "Щит", "Shield name should be correct")
	assert_equals(shield.defense, 3, "Shield defense should be 3")
	
	var food = load("res://game/resources/items/food.tres")
	assert_not_null(food, "Food resource should load")
	assert_equals(food.name, "Провизия", "Food name should be correct")
	assert_equals(food.effect_value, 1, "Food should heal 1 HP")
	
	var rope = load("res://game/resources/items/rope.tres")
	assert_not_null(rope, "Rope resource should load")
	assert_equals(rope.tool_type, "rope", "Rope tool type should be correct")
	
	var torch = load("res://game/resources/items/torch.tres")
	assert_not_null(torch, "Torch resource should load")
	assert_equals(torch.tool_type, "torch", "Torch tool type should be correct")

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