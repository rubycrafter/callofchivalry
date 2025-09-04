extends Node
class_name Knight

signal health_changed(new_health: int, max_health: int)
signal coins_changed(new_coins: int)
signal died()
signal horse_status_changed(has_horse: bool)

const MAX_HEALTH: int = 3
const STARTING_COINS: int = 5

@export var max_health: int = MAX_HEALTH
@export var starting_coins: int = STARTING_COINS

var current_health: int = MAX_HEALTH
var coins: int = STARTING_COINS
var has_horse: bool = true
var inventory: Node

func _ready():
	current_health = max_health
	coins = starting_coins
	
	if not inventory:
		var inventory_script = preload("res://game/scripts/inventory/inventory.gd")
		inventory = inventory_script.new()
		add_child(inventory)

func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health == 0:
		died.emit()

func heal(amount: int) -> void:
	if amount <= 0:
		return
	
	var old_health = current_health
	current_health = min(max_health, current_health + amount)
	
	if current_health != old_health:
		health_changed.emit(current_health, max_health)

func spend_coins(amount: int) -> bool:
	if amount <= 0 or amount > coins:
		return false
	
	coins -= amount
	coins_changed.emit(coins)
	return true

func add_coins(amount: int) -> void:
	if amount <= 0:
		return
	
	coins += amount
	coins_changed.emit(coins)

func lose_horse() -> void:
	if has_horse:
		has_horse = false
		horse_status_changed.emit(has_horse)

func gain_horse() -> void:
	if not has_horse:
		has_horse = true
		horse_status_changed.emit(has_horse)

func can_escape_on_horse() -> bool:
	return has_horse

func can_afford(cost: int) -> bool:
	return coins >= cost

func is_alive() -> bool:
	return current_health > 0

func is_dead() -> bool:
	return current_health <= 0

func reset() -> void:
	current_health = max_health
	coins = starting_coins
	has_horse = true
	
	health_changed.emit(current_health, max_health)
	coins_changed.emit(coins)
	horse_status_changed.emit(has_horse)
	
	if inventory and inventory.has_method("clear"):
		inventory.clear()

func save_data() -> Dictionary:
	var data = {
		"health": current_health,
		"coins": coins,
		"has_horse": has_horse
	}
	
	if inventory and inventory.has_method("save_data"):
		data["inventory"] = inventory.save_data()
	
	return data

func load_data(data: Dictionary) -> void:
	if data.has("health"):
		current_health = data["health"]
		health_changed.emit(current_health, max_health)
	
	if data.has("coins"):
		coins = data["coins"]
		coins_changed.emit(coins)
	
	if data.has("has_horse"):
		has_horse = data["has_horse"]
		horse_status_changed.emit(has_horse)
	
	if data.has("inventory") and inventory and inventory.has_method("load_data"):
		inventory.load_data(data["inventory"])