extends Control

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var add_sword_button: Button = $TestPanel/VBoxContainer/AddSwordButton
@onready var add_horse_button: Button = $TestPanel/VBoxContainer/AddHorseButton
@onready var add_food_button: Button = $TestPanel/VBoxContainer/AddFoodButton
@onready var clear_button: Button = $TestPanel/VBoxContainer/ClearButton

var sword_item = preload("res://game/resources/items/sword.tres")
var horse_item = preload("res://game/resources/items/horse.tres")
var food_item = preload("res://game/resources/items/food.tres")

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
