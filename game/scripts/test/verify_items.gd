extends Node

func _ready():
	print("=== Verifying All 9 Core Items ===\n")
	
	var items = {
		"Sword": "res://game/resources/items/sword.tres",
		"Shield": "res://game/resources/items/shield.tres",
		"Bow & Arrows": "res://game/resources/items/bow_arrows.tres",
		"Rope": "res://game/resources/items/rope.tres",
		"Torch": "res://game/resources/items/torch.tres",
		"Food Rations": "res://game/resources/items/food.tres",
		"Water Flask": "res://game/resources/items/water_flask.tres",
		"Warm Cloak": "res://game/resources/items/warm_cloak.tres",
		"Map": "res://game/resources/items/map.tres"
	}
	
	var all_valid = true
	var total_weight = 0.0
	var item_list = []
	
	for item_name in items:
		var path = items[item_name]
		if ResourceLoader.exists(path):
			var item = load(path) as Item
			if item:
				item_list.append(item)
				total_weight += item.weight
				print("✓ %s" % item_name)
				print("  - Weight: %.1f kg" % item.weight)
				print("  - Size: %dx%d" % [item.size.x, item.size.y])
				print("  - Type: %s" % _get_type_name(item.item_type))
				print("  - Value: %d gold" % item.value)
				print("  - Consumable: %s" % ("Yes" if item.consumable else "No"))
				print("")
			else:
				print("✗ %s - Failed to load as Item resource" % item_name)
				all_valid = false
		else:
			print("✗ %s - File not found at %s" % [item_name, path])
			all_valid = false
	
	print("\n=== Summary ===")
	print("Total items: %d / 9" % item_list.size())
	print("Total weight: %.1f kg" % total_weight)
	print("Max inventory weight: 50.0 kg")
	
	if total_weight <= 50.0:
		print("✓ All items can fit in inventory by weight")
	else:
		print("✗ Items exceed max inventory weight!")
	
	var test_inventory = Inventory.new()
	var all_fit = true
	for item in item_list:
		var slot = test_inventory.find_free_slot(item.size)
		if slot.x >= 0:
			test_inventory.add_item(item, slot)
		else:
			print("✗ %s doesn't fit in 10x10 grid!" % item.name)
			all_fit = false
	
	if all_fit:
		print("✓ All items can fit in 10x10 inventory grid")
	
	if all_valid and all_fit:
		print("\n✓✓✓ ALL ITEMS VERIFIED SUCCESSFULLY ✓✓✓")
	else:
		print("\n✗✗✗ SOME ISSUES FOUND ✗✗✗")
	
	get_tree().quit()

func _get_type_name(type: Item.ItemType) -> String:
	match type:
		Item.ItemType.WEAPON: return "Weapon"
		Item.ItemType.ARMOR: return "Armor"
		Item.ItemType.CONSUMABLE: return "Consumable"
		Item.ItemType.TOOL: return "Tool"
		Item.ItemType.MISC: return "Misc"
		_: return "Unknown"