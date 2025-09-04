extends Control

const GameManager = preload("res://game/scripts/game_manager/game_manager.gd")
const Challenge = preload("res://game/scripts/challenges/challenge.gd")
# Location script is in scenes, not scripts
# const Location = preload("res://game/scripts/locations/location.gd")

# Main menu is now handled by Maaack's template
# @onready var main_menu = $MainMenu
@onready var location_selection_screen = $LocationSelectionScreen
@onready var challenge_screen = $ChallengeScreen
@onready var game_over_screen = $GameOverScreen

var game_manager: GameManager

func _ready() -> void:
	# Connect UI signals
	_connect_ui_signals()
	
	# Don't show main menu by default - wait for game manager
	_hide_all_screens()

func set_game_manager(manager: GameManager) -> void:
	game_manager = manager
	_connect_game_signals()
	
	# Hide main menu when game manager is set
	_hide_all_screens()
	
	# Start location selection
	if game_manager:
		_show_location_selection(true)

func _connect_ui_signals() -> void:
	# Main menu is now handled by Maaack's template
	
	# Location selection signals
	if location_selection_screen:
		location_selection_screen.location_selected.connect(_on_location_selected)
		location_selection_screen.back_pressed.connect(_show_main_menu)
	
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
	# These signals exist but may not be properly exposed
	# game_manager.location_entered.connect(_on_location_entered)
	# game_manager.challenge_started.connect(_on_challenge_started)
	# game_manager.challenge_completed.connect(_on_challenge_completed)
	# game_manager.location_completed.connect(_on_location_completed)

func _show_main_menu() -> void:
	# Main menu is now handled by Maaack's template
	_hide_all_screens()

func _hide_all_screens() -> void:
	# Main menu is now handled by Maaack's template
	if location_selection_screen:
		location_selection_screen.hide_screen()
	if challenge_screen:
		challenge_screen.hide_screen()
	if game_over_screen:
		game_over_screen.hide_screen()

# These handlers are now handled by the main menu from Maaack's template

# Game event handlers
func _on_game_started() -> void:
	_show_location_selection(true)

func _on_game_over(victory: bool) -> void:
	_show_game_over(victory)

func _on_location_entered(location: Location) -> void:
	# The game manager will automatically start the first challenge
	pass

func _on_challenge_started(challenge: Challenge) -> void:
	var available_actions = [] # challenge.get_available_actions(game_manager.knight)
	var location_name = "Test Location"
	
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
	else:
		# Demo mode - show game over
		_show_game_over(true)

# Location selection handlers
func _on_location_selected(location_index: int) -> void:
	if game_manager:
		game_manager.select_starting_location(location_index)
	else:
		# Demo mode - show challenge screen with demo data
		_show_challenge_demo()

func _show_location_selection(is_initial: bool) -> void:
	_hide_all_screens()
	
	var locations = []
	# TODO: Get locations from game_map once it's properly integrated
	
	if location_selection_screen:
		location_selection_screen.show_screen()
		location_selection_screen.setup_locations(locations, is_initial)

func _show_game_over(victory: bool) -> void:
	_hide_all_screens()
	
	var stats = {}
	if game_manager:
		stats = game_manager.get_game_stats()
	else:
		# Demo stats
		stats = {"knight_health": 3, "knight_max_health": 3, "knight_coins": 5}
	
	if game_over_screen:
		game_over_screen.show_screen()
		game_over_screen.setup_game_over(victory, stats)

func _on_return_to_menu() -> void:
	# Return to main menu - let the template handle it
	if game_manager:
		game_manager.reset_game()
	SceneLoader.load_scene("res://game/scenes/menus/main_menu/main_menu_with_animations.tscn")

func _on_restart_game() -> void:
	if game_manager:
		game_manager.reset_game()
		game_manager.start_new_game()

func _update_challenge_screen_status() -> void:
	if not challenge_screen:
		return
	
	# TODO: Update with actual knight stats once properly integrated
	challenge_screen.update_status(3, 3, 5, true, 0.0)

func _show_challenge_demo() -> void:
	# Demo challenge for testing without GameManager
	_hide_all_screens()
	if challenge_screen:
		challenge_screen.show_screen()
		# Create demo challenge
		var demo_challenge = {}
		demo_challenge["title"] = "Demo Challenge"  
		demo_challenge["description"] = "This is a test challenge"
		var demo_actions = [
			{"text": "Action 1"},
			{"text": "Action 2"},
			{"text": "Action 3"}
		]
		challenge_screen.setup_challenge(demo_challenge, demo_actions, "Demo Location")
