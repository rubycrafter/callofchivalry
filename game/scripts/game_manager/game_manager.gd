class_name GameManager
extends Node

signal game_started()
signal game_over(victory: bool)
signal location_entered(location: Location)
signal challenge_started(challenge: Challenge)
signal challenge_completed(challenge: Challenge, action: Challenge.ChallengeAction)
signal location_completed(location: Location)

const Knight = preload("res://game/scripts/knight/knight.gd")
const GameMap = preload("res://game/scripts/game_map/game_map.gd")
const Inventory = preload("res://game/scripts/inventory/inventory.gd")

enum GameState { MENU, PREPARING, IN_LOCATION, CHOOSING_PATH, GAME_OVER }

@export var current_state: GameState = GameState.MENU
@export var save_file_path: String = "user://savegame.dat"

var knight: Knight
var game_map: GameMap
var inventory: Inventory
var current_location: Location
var current_challenge: Challenge
var current_challenge_index: int = 0

func _init() -> void:
	knight = Knight.new()
	game_map = GameMap.new()
	inventory = Inventory.new()
	
	_connect_signals()

func _connect_signals() -> void:
	knight.health_changed.connect(_on_knight_health_changed)
	knight.died.connect(_on_knight_died)
	knight.coins_changed.connect(_on_knight_coins_changed)
	
	if game_map:
		game_map.location_selected.connect(_on_location_selected)
		game_map.journey_completed.connect(_on_journey_completed)

func start_new_game() -> void:
	reset_game()
	current_state = GameState.PREPARING
	game_started.emit()

func reset_game() -> void:
	knight.reset()
	game_map.reset()
	inventory.clear_inventory()
	current_location = null
	current_challenge = null
	current_challenge_index = 0
	current_state = GameState.MENU

func select_starting_location(location_index: int) -> void:
	if current_state != GameState.PREPARING:
		return
	
	var choices = game_map.get_initial_location_choices()
	if location_index >= 0 and location_index < choices.size():
		var selected_location = choices[location_index]
		game_map.start_journey_from(selected_location)
		enter_location(selected_location)

func enter_location(location: Location) -> void:
	current_location = location
	current_location.enter_location()
	current_challenge_index = 0
	current_state = GameState.IN_LOCATION
	location_entered.emit(location)
	
	if current_location.selected_challenges.size() > 0:
		start_next_challenge()

func start_next_challenge() -> void:
	if not current_location:
		return
	
	if current_challenge_index >= current_location.selected_challenges.size():
		complete_location()
		return
	
	current_challenge = current_location.selected_challenges[current_challenge_index]
	challenge_started.emit(current_challenge)

func execute_challenge_action(action_index: int) -> bool:
	if not current_challenge:
		return false
	
	var available_actions = current_challenge.get_available_actions(knight)
	if action_index < 0 or action_index >= available_actions.size():
		return false
	
	var action = available_actions[action_index]
	var success = _apply_action_effects(action)
	
	if success:
		challenge_completed.emit(current_challenge, action)
		current_challenge_index += 1
		
		if knight.is_dead():
			end_game(false)
		else:
			start_next_challenge()
	
	return success

func _apply_action_effects(action: Challenge.ChallengeAction) -> bool:
	match action.type:
		Challenge.ActionType.USE_ITEM:
			if action.item_required:
				var item = inventory.find_item_by_name(action.item_required)
				if item:
					inventory.remove_item(item)
					_apply_rewards(action)
					return true
			return false
		
		Challenge.ActionType.SPEND_COINS:
			if knight.can_afford(action.coins_required):
				knight.spend_coins(action.coins_required)
				_apply_rewards(action)
				return true
			return false
		
		Challenge.ActionType.TAKE_DAMAGE:
			knight.take_damage(action.damage_taken)
			_apply_rewards(action)
			return true
		
		Challenge.ActionType.ESCAPE_ON_HORSE:
			if knight.has_horse:
				if action.loses_horse:
					knight.lose_horse()
				_apply_rewards(action)
				return true
			return false
		
		Challenge.ActionType.CUSTOM:
			_apply_rewards(action)
			return true
		
		_:
			return false

func _apply_rewards(action: Challenge.ChallengeAction) -> void:
	if action.reward_coins > 0:
		knight.add_coins(action.reward_coins)
	
	if action.reward_item:
		var reward_item = _create_item_from_name(action.reward_item)
		if reward_item:
			inventory.add_item(reward_item)

func _create_item_from_name(item_name: String) -> Item:
	match item_name:
		"Меч":
			var item = Item.new()
			item.name = "Меч"
			item.weight = 2.0
			item.size = Vector2(1, 3)
			return item
		"Щит":
			var item = Item.new()
			item.name = "Щит"
			item.weight = 3.0
			item.size = Vector2(2, 2)
			return item
		"Эликсир здоровья":
			var item = Item.new()
			item.name = "Эликсир здоровья"
			item.weight = 0.3
			item.size = Vector2(1, 1)
			return item
		"Конь":
			knight.gain_horse()
			return null
		"Перо феникса":
			var item = Item.new()
			item.name = "Перо феникса"
			item.weight = 0.1
			item.size = Vector2(1, 1)
			return item
		_:
			var item = Item.new()
			item.name = item_name
			item.weight = 0.5
			item.size = Vector2(1, 1)
			return item

func complete_location() -> void:
	if current_location:
		location_completed.emit(current_location)
	
	current_state = GameState.CHOOSING_PATH
	show_path_choices()

func show_path_choices() -> Array[Location]:
	return game_map.get_available_next_locations()

func choose_next_location(location_index: int) -> void:
	if current_state != GameState.CHOOSING_PATH:
		return
	
	var choices = game_map.get_available_next_locations()
	if location_index >= 0 and location_index < choices.size():
		var selected_location = choices[location_index]
		if game_map.move_to_location(selected_location):
			enter_location(selected_location)

func end_game(victory: bool) -> void:
	current_state = GameState.GAME_OVER
	game_over.emit(victory)

func _on_knight_health_changed(new_health: int, max_health: int) -> void:
	if new_health <= 0 and current_state != GameState.GAME_OVER:
		end_game(false)

func _on_knight_died() -> void:
	if current_state != GameState.GAME_OVER:
		end_game(false)

func _on_knight_coins_changed(new_coins: int) -> void:
	pass

func _on_location_selected(location: Location) -> void:
	pass

func _on_journey_completed() -> void:
	if not knight.is_dead():
		end_game(true)

func save_game() -> Dictionary:
	var save_data = {
		"version": 1,
		"state": current_state,
		"knight": knight.get_save_data(),
		"inventory": inventory.get_save_data(),
		"game_map": {
			"current_row": game_map.current_row,
			"current_position": game_map.current_position,
			"visited_locations": game_map.visited_locations,
			"completed_locations": game_map.completed_locations
		},
		"current_challenge_index": current_challenge_index
	}
	
	if current_location:
		save_data["current_location"] = current_location.name
	
	return save_data

func load_game(save_data: Dictionary) -> bool:
	if not save_data.has("version") or save_data.version != 1:
		return false
	
	reset_game()
	
	current_state = save_data.get("state", GameState.MENU)
	knight.load_save_data(save_data.get("knight", {}))
	inventory.load_save_data(save_data.get("inventory", {}))
	
	var map_data = save_data.get("game_map", {})
	game_map.current_row = map_data.get("current_row", GameMap.MapRow.ROW_1)
	game_map.current_position = map_data.get("current_position", GameMap.LocationPosition.CENTER)
	game_map.visited_locations = map_data.get("visited_locations", [])
	game_map.completed_locations = map_data.get("completed_locations", [])
	
	current_challenge_index = save_data.get("current_challenge_index", 0)
	
	if save_data.has("current_location"):
		var location = game_map.get_current_location()
		if location:
			current_location = location
			current_location.enter_location()
	
	return true

func save_to_file() -> bool:
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if not save_file:
		return false
	
	var save_data = save_game()
	save_file.store_var(save_data)
	save_file.close()
	return true

func load_from_file() -> bool:
	if not FileAccess.file_exists(save_file_path):
		return false
	
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if not save_file:
		return false
	
	var save_data = save_file.get_var()
	save_file.close()
	
	return load_game(save_data)

func get_game_stats() -> Dictionary:
	return {
		"knight_health": knight.health,
		"knight_max_health": knight.max_health,
		"knight_coins": knight.coins,
		"knight_has_horse": knight.has_horse,
		"inventory_items": inventory.items.size(),
		"locations_visited": game_map.visited_locations.size(),
		"locations_completed": game_map.completed_locations.size(),
		"progress": game_map.get_progress_percentage(),
		"current_state": GameState.keys()[current_state]
	}