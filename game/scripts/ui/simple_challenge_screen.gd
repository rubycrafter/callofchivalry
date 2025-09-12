extends Control

signal action_selected(index: int)
signal inventory_button_pressed

@onready var location_label: Label = $VBoxContainer/LocationLabel
@onready var challenge_title: Label = $VBoxContainer/ChallengeTitle
@onready var challenge_description: RichTextLabel = $VBoxContainer/ChallengeDescription
@onready var actions_container: VBoxContainer = $VBoxContainer/ActionsContainer
@onready var health_label: Label = $VBoxContainer/StatusBar/HealthLabel
@onready var coins_label: Label = $VBoxContainer/StatusBar/CoinsLabel
@onready var horse_label: Label = $VBoxContainer/StatusBar/HorseLabel
@onready var inventory_button: Button = $VBoxContainer/StatusBar/InventoryButton

var action_buttons: Array[Button] = []

func _ready() -> void:
	if inventory_button:
		inventory_button.pressed.connect(_on_inventory_button_pressed)

func _on_inventory_button_pressed() -> void:
	inventory_button_pressed.emit()

func setup_challenge(challenge, actions: Array, location_name: String = "") -> void:
	if location_label:
		location_label.text = location_name
	
	if challenge_title:
		if challenge is Dictionary:
			challenge_title.text = challenge.get("title", "Испытание")
		elif challenge != null and "title" in challenge:
			challenge_title.text = challenge.title
	
	if challenge_description:
		if challenge is Dictionary:
			challenge_description.text = challenge.get("description", "")
		elif challenge != null and "description" in challenge:
			challenge_description.text = challenge.description
	
	# Clear existing action buttons
	for button in action_buttons:
		button.queue_free()
	action_buttons.clear()
	
	# Create action buttons
	if actions_container:
		for i in range(actions.size()):
			var action = actions[i]
			var button = Button.new()
			button.custom_minimum_size = Vector2(400, 50)
			
			if action is Dictionary:
				button.text = action.get("text", "Действие " + str(i + 1))
			elif action != null and "text" in action:
				button.text = action.text
			else:
				button.text = "Действие " + str(i + 1)
			
			button.pressed.connect(_on_action_button_pressed.bind(i))
			actions_container.add_child(button)
			action_buttons.append(button)

func _on_action_button_pressed(index: int) -> void:
	action_selected.emit(index)

func update_status(health: int, max_health: int, coins: int, has_horse: bool, progress: float) -> void:
	if health_label:
		health_label.text = "Здоровье: %d/%d" % [health, max_health]
	if coins_label:
		coins_label.text = "Золото: %d" % coins
	if horse_label:
		horse_label.text = "Конь: %s" % ("Да" if has_horse else "Нет")

func show_action_result(action) -> void:
	# Simple implementation - just hide the screen after action
	pass

func show_screen() -> void:
	show()

func hide_screen() -> void:
	hide()