class_name GameState
extends Resource

const STATE_NAME : String = "GameState"
const FILE_PATH = "res://game/scripts/game_state.gd"

@export var level_states : Dictionary = {}
@export var location_states : Dictionary = {}
@export var current_level_path : String
@export var current_location_path : String
@export var continue_level_path : String
@export var continue_location_path : String
@export var times_played : int

static func get_level_state(level_state_key : String) -> LevelState:
	if not has_game_state(): 
		return
	var game_state := get_or_create_state()
	if level_state_key.is_empty() : return
	if level_state_key in game_state.level_states:
		return game_state.level_states[level_state_key] 
	else:
		var new_level_state := LevelState.new()
		game_state.level_states[level_state_key] = new_level_state
		GlobalState.save()
		return new_level_state

static func has_game_state() -> bool:
	return GlobalState.has_state(STATE_NAME)

static func get_or_create_state() -> GameState:
	return GlobalState.get_or_create_state(STATE_NAME, FILE_PATH)

static func get_current_level_path() -> String:
	if not has_game_state(): 
		return ""
	var game_state := get_or_create_state()
	return game_state.current_level_path

static func get_levels_reached() -> int:
	if not has_game_state(): 
		return 0
	var game_state := get_or_create_state()
	return game_state.level_states.size()

static func level_reached(level_path : String) -> void:
	var game_state := get_or_create_state()
	game_state.current_level_path = level_path
	game_state.continue_level_path = level_path
	get_level_state(level_path)
	GlobalState.save()

static func set_current_level(level_path : String) -> void:
	var game_state := get_or_create_state()
	game_state.current_level_path = level_path
	GlobalState.save()

static func start_game() -> void:
	var game_state := get_or_create_state()
	game_state.times_played += 1
	GlobalState.save()

static func continue_game() -> void:
	var game_state := get_or_create_state()
	game_state.current_level_path = game_state.continue_level_path
	GlobalState.save()

static func reset() -> void:
	var game_state := get_or_create_state()
	game_state.level_states = {}
	game_state.location_states = {}
	game_state.current_level_path = ""
	game_state.current_location_path = ""
	game_state.continue_level_path = ""
	game_state.continue_location_path = ""
	GlobalState.save()

static func get_location_state(location_state_key : String) -> Resource:
	if not has_game_state(): 
		return
	var game_state := get_or_create_state()
	if location_state_key.is_empty() : return
	if location_state_key in game_state.location_states:
		return game_state.location_states[location_state_key] 
	else:
		var new_location_state := Resource.new()
		game_state.location_states[location_state_key] = new_location_state
		GlobalState.save()
		return new_location_state

static func save_game() -> void:
	GlobalState.save()
