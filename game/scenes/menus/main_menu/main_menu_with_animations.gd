extends MainMenu

@export var level_select_packed_scene: PackedScene
@export var confirm_new_game : bool = true

var level_select_scene : Node
var animation_state_machine : AnimationNodeStateMachinePlayback

func load_game_scene() -> void:
	GameState.start_game()
	super.load_game_scene()

func new_game() -> void:
	if confirm_new_game and GameState.has_game_state():
		%NewGameConfirmationDialog.popup_centered()
	else:
		GameState.reset()
		load_game_scene()

func intro_done() -> void:
	animation_state_machine.travel("OpenMainMenu")

func _is_in_intro() -> bool:
	return animation_state_machine.get_current_node() == "Intro"

func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _open_sub_menu(menu : Node) -> void:
	super._open_sub_menu(menu)
	animation_state_machine.travel("OpenSubMenu")

func _close_sub_menu() -> void:
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")

func _input(event : InputEvent) -> void:
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	super._input(event)

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
	_add_debug_buttons()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")

func _add_debug_buttons() -> void:
	# Add debug buttons only in debug builds
	if not OS.is_debug_build() and not OS.has_feature("editor"):
		return
	
	var button_container = get_node("MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer")
	
	# Add separator
	var separator = HSeparator.new()
	button_container.add_child(separator)
	
	# Add Test Inventory button
	var test_inventory_btn = Button.new()
	test_inventory_btn.name = "TestInventoryButton"
	test_inventory_btn.text = "Test Inventory"
	test_inventory_btn.pressed.connect(_on_test_inventory_button_pressed)
	button_container.add_child(test_inventory_btn)
	
	# Add Show Inventory button
	var show_inventory_btn = Button.new()
	show_inventory_btn.name = "ShowInventoryButton"
	show_inventory_btn.text = "Show Inventory UI"
	show_inventory_btn.pressed.connect(_on_show_inventory_button_pressed)
	button_container.add_child(show_inventory_btn)

func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_game_scene()

func _on_level_select_button_pressed() -> void:
	_open_sub_menu(level_select_scene)

func _on_new_game_confirmation_dialog_confirmed():
	GameState.reset()
	load_game_scene()

func _on_test_inventory_button_pressed() -> void:
	var inventory_scene = preload("res://game/scenes/test/inventory_test.tscn")
	get_tree().change_scene_to_packed(inventory_scene)

func _on_show_inventory_button_pressed() -> void:
	var inventory_ui = preload("res://game/scenes/inventory/inventory_ui.tscn").instantiate()
	get_tree().root.add_child(inventory_ui)
