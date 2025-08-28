extends Control

signal new_game_pressed()
signal continue_game_pressed()
signal quit_pressed()

@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	_connect_signals()
	_update_continue_button()
	
func _connect_signals() -> void:
	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _update_continue_button() -> void:
	var save_exists = FileAccess.file_exists("user://savegame.dat")
	continue_button.disabled = not save_exists
	if not save_exists:
		continue_button.modulate.a = 0.5
	else:
		continue_button.modulate.a = 1.0

func _on_new_game_pressed() -> void:
	new_game_pressed.emit()

func _on_continue_pressed() -> void:
	if not continue_button.disabled:
		continue_game_pressed.emit()

func _on_quit_pressed() -> void:
	quit_pressed.emit()

func show_menu() -> void:
	_update_continue_button()
	show()

func hide_menu() -> void:
	hide()
