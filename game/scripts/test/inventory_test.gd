extends Control

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var add_sword_button: Button = $TestPanel/VBoxContainer/AddSwordButton
@onready var add_horse_button: Button = $TestPanel/VBoxContainer/AddHorseButton
@onready var add_food_button: Button = $TestPanel/VBoxContainer/AddFoodButton
@onready var clear_button: Button = $TestPanel/VBoxContainer/ClearButton

var sword_item = preload("res://game/resources/items/sword.tres")
var horse_item = preload("res://game/resources/items/horse.tres")
var food_item = preload("res://game/resources/items/food.tres")
var shield_item = preload("res://game/resources/items/shield.tres")
var bow_arrows_item = preload("res://game/resources/items/bow_arrows.tres")
var rope_item = preload("res://game/resources/items/rope.tres")
var torch_item = preload("res://game/resources/items/torch.tres")
var water_flask_item = preload("res://game/resources/items/water_flask.tres")
var warm_cloak_item = preload("res://game/resources/items/warm_cloak.tres")
var map_item = preload("res://game/resources/items/map.tres")

func _ready():
	add_sword_button.pressed.connect(_on_add_sword)
	add_horse_button.pressed.connect(_on_add_horse)
	add_food_button.pressed.connect(_on_add_food)
	clear_button.pressed.connect(_on_clear_inventory)

func _on_add_sword():
	if not inventory_ui.add_item_auto(sword_item):
		print("Cannot add sword - inventory full or too heavy")

func _on_add_horse():
	if not inventory_ui.add_item_auto(horse_item):
		print("Cannot add horse - inventory full or too heavy")

func _on_add_food():
	if not inventory_ui.add_item_auto(food_item):
		print("Cannot add food - inventory full or too heavy")

func _on_clear_inventory():
	inventory_ui.inventory.clear()
	# Force refresh all slots
	for slot in inventory_ui.slots:
		slot.clear()
		slot.clear_occupied()

func _input(event):
	if event.is_action_pressed("ui_text_submit"):
		_test_all_items()

func _test_all_items():
	print("Testing all 10 core items...")
	inventory_ui.inventory.clear()
	
	var all_items = [
		sword_item,
		shield_item,
		bow_arrows_item,
		horse_item,
		rope_item,
		torch_item,
		food_item,
		water_flask_item,
		warm_cloak_item,
		map_item
	]
	
	var total_weight = 0.0
	for item in all_items:
		print("Item: %s, Weight: %s kg, Size: %s" % [item.name, item.weight, item.size])
		total_weight += item.weight
		if inventory_ui.add_item_auto(item):
			print("  ✓ Added successfully")
		else:
			print("  ✗ Failed to add")
	
	print("\nTotal weight: %s / %s kg" % [total_weight, inventory_ui.inventory.max_weight])
	print("Press Enter to test adding all items again")
