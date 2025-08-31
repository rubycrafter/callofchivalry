extends Control

signal action_selected(index: int)

@onready var location_label: Label = $VBoxContainer/LocationLabel
@onready var challenge_title: Label = $VBoxContainer/ChallengePanel/VBoxContainer/ChallengeTitle
@onready var challenge_description: RichTextLabel = $VBoxContainer/ChallengePanel/VBoxContainer/ChallengeDescription
@onready var actions_container: VBoxContainer = $VBoxContainer/ActionsPanel/VBoxContainer/ActionsContainer
@onready var result_label: Label = $VBoxContainer/ResultPanel/ResultLabel
@onready var result_panel: Panel = $VBoxContainer/ResultPanel
@onready var continue_button: Button = $VBoxContainer/ResultPanel/ContinueButton
@onready var status_bar: HBoxContainer = $StatusBar

# Status bar elements
@onready var health_label: Label = $StatusBar/HealthLabel
@onready var coins_label: Label = $StatusBar/CoinsLabel
@onready var horse_label: Label = $StatusBar/HorseLabel
@onready var progress_label: Label = $StatusBar/ProgressLabel

var action_buttons: Array[Button] = []
var current_challenge # Can be Challenge or dictionary for demo
var available_actions: Array = []

func _ready() -> void:
	_setup_ui()
	result_panel.hide()

func _setup_ui() -> void:
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)

func setup_challenge(challenge, actions: Array, location_name: String = "") -> void:
	current_challenge = challenge
	available_actions = actions
	
	# Update location name
	if location_label:
		location_label.text = location_name
	
	# Update challenge info (support both Challenge object and dictionary)
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
	for i in range(actions.size()):
		var action = actions[i]
		var button = Button.new()
		button.custom_minimum_size = Vector2(400, 50)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Format button text (support both action objects and dictionaries)
		if action is Dictionary:
			button.text = action.get("text", "Действие")
		elif action != null and "text" in action:
			var button_text = action.text
			# Try to add type-specific info if available
			if "type" in action:
				match action.type:
					Challenge.ActionType.USE_ITEM:
						if "item_required" in action and action.item_required:
							button_text += " [Требуется: %s]" % action.item_required
					Challenge.ActionType.SPEND_COINS:
						if "coins_required" in action:
							button_text += " [%d монет]" % action.coins_required
					Challenge.ActionType.TAKE_DAMAGE:
						if "damage_taken" in action:
							button_text += " [-%d здоровья]" % action.damage_taken
					Challenge.ActionType.ESCAPE_ON_HORSE:
						button_text += " [Требуется конь]"
			button.text = button_text
		else:
			button.text = "Действие %d" % (i + 1)
		
		# Connect signal
		button.pressed.connect(_on_action_button_pressed.bind(i))
		
		actions_container.add_child(button)
		action_buttons.append(button)
	
	# Hide result panel
	result_panel.hide()

func show_action_result(action) -> void:
	# Show result message (support both action objects and dictionaries)
	if result_label:
		if action is Dictionary:
			result_label.text = action.get("success_message", "Действие выполнено!")
			
			# Add reward info if any
			if action.has("reward_coins") and action.reward_coins > 0:
				result_label.text += "\n\nПолучено %d монет!" % action.reward_coins
			
			if action.has("reward_item") and action.reward_item:
				result_label.text += "\n\nПолучен предмет: %s" % action.reward_item
		elif action != null and "success_message" in action:
			result_label.text = action.success_message
			
			# Add reward info if any
			if "reward_coins" in action and action.reward_coins > 0:
				result_label.text += "\n\nПолучено %d монет!" % action.reward_coins
			
			if "reward_item" in action and action.reward_item:
				result_label.text += "\n\nПолучен предмет: %s" % action.reward_item
	
	# Disable action buttons
	for button in action_buttons:
		button.disabled = true
	
	# Show result panel
	result_panel.show()

func update_status(knight_health: int, max_health: int, coins: int, has_horse: bool, progress: float) -> void:
	if health_label:
		health_label.text = "Здоровье: %d/%d" % [knight_health, max_health]
		health_label.modulate = Color.RED if knight_health == 1 else Color.WHITE
	
	if coins_label:
		coins_label.text = "Монеты: %d" % coins
	
	if horse_label:
		horse_label.text = "Конь: %s" % ("Есть" if has_horse else "Нет")
		horse_label.modulate = Color.GREEN if has_horse else Color.GRAY
	
	if progress_label:
		progress_label.text = "Прогресс: %.0f%%" % progress

func _on_action_button_pressed(index: int) -> void:
	action_selected.emit(index)

func _on_continue_pressed() -> void:
	result_panel.hide()

func show_screen() -> void:
	show()

func hide_screen() -> void:
	hide()
