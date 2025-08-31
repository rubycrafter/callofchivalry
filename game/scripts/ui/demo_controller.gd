extends Control

# Simple demo controller to show working UI

@onready var main_menu = $MainMenu
@onready var location_selection_screen = $LocationSelectionScreen  
@onready var challenge_screen = $ChallengeScreen
@onready var game_over_screen = $GameOverScreen

var demo_locations = [
	{"name": "Лес", "description": "Тёмный лес полный опасностей"},
	{"name": "Степь", "description": "Бескрайние просторы степи"},
	{"name": "Тундра", "description": "Холодная арктическая пустыня"}
]

var demo_challenge = {
	"title": "Встреча с бандитами",
	"description": "Группа разбойников преградила вам путь и требует золото или жизнь!"
}

var demo_actions = [
	{"text": "Атаковать мечом [Требуется: Меч]"},
	{"text": "Откупиться [5 монет]"},
	{"text": "Попытаться убежать [-1 здоровья]"},
	{"text": "Ускакать на коне [Требуется конь]"}
]

func _ready() -> void:
	_connect_ui_signals()
	_show_main_menu()

func _connect_ui_signals() -> void:
	# Main menu
	if main_menu:
		main_menu.new_game_pressed.connect(_on_new_game)
		main_menu.continue_game_pressed.connect(_on_continue_game)
		main_menu.quit_pressed.connect(_on_quit_game)
	
	# Location selection
	if location_selection_screen:
		location_selection_screen.location_selected.connect(_on_location_selected)
		location_selection_screen.back_pressed.connect(_show_main_menu)
	
	# Challenge screen
	if challenge_screen:
		challenge_screen.action_selected.connect(_on_action_selected)
	
	# Game over
	if game_over_screen:
		game_over_screen.return_to_menu.connect(_show_main_menu)
		game_over_screen.restart_game.connect(_on_new_game)

func _show_main_menu() -> void:
	_hide_all_screens()
	if main_menu:
		main_menu.show_menu()

func _hide_all_screens() -> void:
	if main_menu:
		main_menu.hide()
	if location_selection_screen:
		location_selection_screen.hide()
	if challenge_screen:
		challenge_screen.hide()
	if game_over_screen:
		game_over_screen.hide()

func _on_new_game() -> void:
	print("Starting new game...")
	_hide_all_screens()
	if location_selection_screen:
		location_selection_screen.show()
		location_selection_screen.setup_locations(demo_locations, true)

func _on_continue_game() -> void:
	print("Continue not implemented in demo")

func _on_quit_game() -> void:
	get_tree().quit()

func _on_location_selected(index: int) -> void:
	print("Selected location: ", demo_locations[index].name)
	_hide_all_screens()
	if challenge_screen:
		challenge_screen.show()
		# Create a simple challenge object for demo
		var challenge = {}
		challenge.title = demo_challenge.title
		challenge.description = demo_challenge.description
		challenge_screen.setup_challenge(challenge, demo_actions, demo_locations[index].name)
		challenge_screen.update_status(3, 3, 5, true, 25.0)

func _on_action_selected(index: int) -> void:
	print("Selected action: ", demo_actions[index].text)
	if challenge_screen:
		# Show result
		var action = {}
		action.success_message = "Вы успешно преодолели испытание!"
		action.reward_coins = 3
		action.reward_item = null
		challenge_screen.show_action_result(action)
		
		# After 2 seconds show game over
		await get_tree().create_timer(2.0).timeout
		_show_game_over(true)

func _show_game_over(victory: bool) -> void:
	_hide_all_screens()
	if game_over_screen:
		game_over_screen.show()
		var stats = {
			"locations_visited": 3,
			"locations_completed": 2,
			"knight_health": 2,
			"knight_max_health": 3,
			"knight_coins": 8,
			"knight_has_horse": true,
			"inventory_items": 5,
			"progress": 50.0
		}
		game_over_screen.setup_game_over(victory, stats)