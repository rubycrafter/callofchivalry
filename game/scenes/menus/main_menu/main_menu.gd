extends MainMenu

@export var level_select_packed_scene: PackedScene
@export var confirm_new_game : bool = true
@export var demo_scene_path: String = "res://game/scenes/demo.tscn"

var level_select_scene : Node

func load_game_scene() -> void:
	GameState.start_game()
	super.load_game_scene()

func new_game() -> void:
	if confirm_new_game and GameState.has_game_state():
		%NewGameConfirmationDialog.popup_centered()
	else:
		GameState.reset()
		load_game_scene()

func _add_level_select_if_set() -> void: 
	if level_select_packed_scene == null: return
	if GameState.get_levels_reached() <= 1 : return
	level_select_scene = level_select_packed_scene.instantiate()
	level_select_scene.hide()
	%LevelSelectContainer.call_deferred("add_child", level_select_scene)
	if level_select_scene.has_signal("level_selected"):
		level_select_scene.connect("level_selected", load_game_scene)
	%LevelSelectButton.show()

func _show_continue_if_set() -> void:
	if GameState.has_game_state():
		%ContinueGameButton.show()

func _ready() -> void:
	super._ready()
	_add_level_select_if_set()
	_show_continue_if_set()
	_add_demo_button()

func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_game_scene()

func _on_level_select_button_pressed() -> void:
	_open_sub_menu(level_select_scene)

func _on_new_game_confirmation_dialog_confirmed() -> void:
	GameState.reset()
	load_game_scene()

func _add_demo_button() -> void:
	# Find the menu buttons container
	var menu_buttons_container = find_child("MenuButtonsContainer", true, false)
	if not menu_buttons_container:
		# Try alternative name
		menu_buttons_container = find_child("MenuButtons", true, false)
		if not menu_buttons_container:
			print("Could not find menu buttons container")
			return
	
	# Create demo button
	var demo_button = Button.new()
	demo_button.name = "DemoButton"
	demo_button.text = "🎮 Demo UI"
	demo_button.custom_minimum_size = Vector2(200, 60)
	demo_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	demo_button.pressed.connect(_on_demo_button_pressed)
	
	# Add button after New Game button
	menu_buttons_container.add_child(demo_button)
	menu_buttons_container.move_child(demo_button, 1)

func _on_demo_button_pressed() -> void:
	if demo_scene_path != "":
		get_tree().change_scene_to_file(demo_scene_path)
