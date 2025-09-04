extends Node

signal level_lost
signal level_won
signal level_won_and_changed(level_path : String)

const GameManager = preload("res://game/scripts/game_manager/game_manager.gd")

@export_file("*.tscn") var next_level_path : String

@onready var location_selection_screen = $UILayer/LocationSelectionScreen
@onready var challenge_screen = $UILayer/ChallengeScreen
@onready var game_over_screen = $UILayer/GameOverScreen
@onready var inventory_ui = $UILayer/InventoryUI

var game_manager: GameManager
var level_state : LevelState

func _ready() -> void:
	print("CallOfChivalryGame: Starting _ready()")
	
	# Check UI elements exist
	print("UI Elements check:")
	print("- LocationSelectionScreen: ", location_selection_screen != null)
	print("- ChallengeScreen: ", challenge_screen != null)
	print("- GameOverScreen: ", game_over_screen != null)
	print("- InventoryUI: ", inventory_ui != null)
	
	level_state = GameState.get_level_state(scene_file_path)
	
	print("Creating GameManager...")
	# Create GameManager
	game_manager = GameManager.new()
	add_child(game_manager)
	
	print("Connecting UI signals...")
	# Connect UI signals
	_connect_ui_signals()
	
	print("Connecting game signals...")
	# Connect game manager signals
	_connect_game_signals()
	
	print("Checking for saved game...")
	# Check if we should load a saved game
	var should_continue = GameState.get_current_level_path() != ""
	if should_continue and game_manager.load_from_file():
		print("Loading saved game...")
		# Resume from saved state
		_resume_from_saved_state()
	else:
		print("Starting new game...")
		# Start new game
		game_manager.start_new_game()
	
	print("CallOfChivalryGame: _ready() completed")

func _resume_from_saved_state() -> void:
	# Check current state and show appropriate UI
	match game_manager.current_state:
		GameManager.State.IN_LOCATION:
			if game_manager.current_challenge:
				_on_challenge_started(game_manager.current_challenge)
			else:
				game_manager.start_next_challenge()
		GameManager.State.CHOOSING_PATH:
			_show_location_selection(false)
		GameManager.State.PREPARING:
			_show_location_selection(true)
		_:
			game_manager.start_new_game()

func _connect_ui_signals() -> void:
	# Location selection signals
	if location_selection_screen:
		location_selection_screen.location_selected.connect(_on_location_selected)
		location_selection_screen.back_pressed.connect(_on_back_to_menu)
	
	# Challenge screen signals
	if challenge_screen:
		challenge_screen.action_selected.connect(_on_challenge_action_selected)
	
	# Game over screen signals
	if game_over_screen:
		game_over_screen.return_to_menu.connect(_on_return_to_menu)
		game_over_screen.restart_game.connect(_on_restart_game)

func _connect_game_signals() -> void:
	if game_manager:
		game_manager.game_started.connect(_on_game_started)
		game_manager.game_over.connect(_on_game_over)
		game_manager.location_entered.connect(_on_location_entered)
		game_manager.challenge_started.connect(_on_challenge_started)
		game_manager.challenge_completed.connect(_on_challenge_completed)
		game_manager.location_completed.connect(_on_location_completed)

func _on_game_started() -> void:
	_show_location_selection(true)

func _on_game_over(victory: bool) -> void:
	_show_game_over(victory)
	
	# Emit signals for template integration
	if victory:
		if not next_level_path.is_empty():
			level_won_and_changed.emit(next_level_path)
		else:
			level_won.emit()
	else:
		level_lost.emit()

func _on_location_entered(location) -> void:
	# The game manager will automatically start the first challenge
	pass

func _on_challenge_started(challenge) -> void:
	var available_actions = challenge.get_available_actions(game_manager.knight)
	var location_name = game_manager.current_location.name if game_manager.current_location else "Unknown"
	
	_hide_all_screens()
	if challenge_screen:
		challenge_screen.show_screen()
		challenge_screen.setup_challenge(challenge, available_actions, location_name)
		_update_challenge_screen_status()

func _on_challenge_completed(challenge, action) -> void:
	if challenge_screen:
		challenge_screen.show_action_result(action)
		_update_challenge_screen_status()
	
	# Save game after each completed challenge
	game_manager.save_to_file()

func _on_location_completed(location) -> void:
	# Show path selection
	_show_location_selection(false)

func _on_challenge_action_selected(action_index: int) -> void:
	if game_manager:
		game_manager.execute_challenge_action(action_index)

# Location selection handlers
func _on_location_selected(location_index: int) -> void:
	if game_manager:
		if game_manager.current_state == GameManager.State.PREPARING:
			game_manager.select_starting_location(location_index)
		else:
			game_manager.choose_next_location(location_index)

func _on_back_to_menu() -> void:
	SceneLoader.load_scene("res://game/scenes/menus/main_menu/main_menu_with_animations.tscn")

func _show_location_selection(is_initial: bool) -> void:
	_hide_all_screens()
	
	var locations = []
	if is_initial:
		locations = game_manager.game_map.get_initial_location_choices()
	else:
		locations = game_manager.game_map.get_available_next_locations()
	
	if location_selection_screen:
		location_selection_screen.show_screen()
		location_selection_screen.setup_locations(locations, is_initial)

func _show_game_over(victory: bool) -> void:
	_hide_all_screens()
	
	var stats = game_manager.get_game_stats() if game_manager else {}
	
	if game_over_screen:
		game_over_screen.show_screen()
		game_over_screen.setup_game_over(victory, stats)

func _on_return_to_menu() -> void:
	if game_manager:
		game_manager.reset_game()
	SceneLoader.load_scene("res://game/scenes/menus/main_menu/main_menu_with_animations.tscn")

func _on_restart_game() -> void:
	if game_manager:
		game_manager.reset_game()
		game_manager.start_new_game()

func _update_challenge_screen_status() -> void:
	if not challenge_screen or not game_manager:
		return
	
	var knight = game_manager.knight
	challenge_screen.update_status(
		knight.current_health,
		knight.max_health,
		knight.coins,
		knight.has_horse,
		game_manager.game_map.get_progress_percentage()
	)

func _hide_all_screens() -> void:
	if location_selection_screen:
		location_selection_screen.hide_screen()
	if challenge_screen:
		challenge_screen.hide_screen()
	if game_over_screen:
		game_over_screen.hide_screen()
	if inventory_ui:
		inventory_ui.hide()

func _unhandled_input(event: InputEvent) -> void:
	# Toggle inventory with I key
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_I:
			if inventory_ui:
				inventory_ui.visible = not inventory_ui.visible
				if inventory_ui.visible and game_manager:
					inventory_ui.set_inventory(game_manager.inventory)