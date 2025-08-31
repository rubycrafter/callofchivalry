extends Node

signal location_completed
signal challenge_completed(challenge_result: Dictionary)

@export_file("*.tscn") var next_location_path : String
@export var location_name: String = "Unknown Location"
@export var location_type: LocationType = LocationType.FOREST

enum LocationType {
	FOREST,
	STEPPE,
	TUNDRA,
	SWAMP,
	DESERT,
	GLACIER,
	MOUNTAIN,
	VOLCANO,
	CAVE,
	DRAGON_LAIR
}

var challenges: Array[Challenge] = []
var current_challenge_index: int = 0
var location_state: LocationState

@onready var challenge_container: Control = %ChallengeContainer
@onready var location_title: Label = %LocationTitle
@onready var location_background: ColorRect = %BackgroundColor

func _ready() -> void:
	location_state = GameState.get_location_state(scene_file_path)
	_setup_location()
	_load_challenges()
	_show_current_challenge()

func _setup_location() -> void:
	if location_title:
		location_title.text = location_name
	
	# Set background color based on location type
	if location_background:
		location_background.color = _get_location_color()

func _get_location_color() -> Color:
	match location_type:
		LocationType.FOREST:
			return Color(0.1, 0.4, 0.1, 1.0)  # Dark green
		LocationType.STEPPE:
			return Color(0.7, 0.6, 0.3, 1.0)  # Yellow-brown
		LocationType.TUNDRA:
			return Color(0.7, 0.8, 0.9, 1.0)  # Light blue
		LocationType.SWAMP:
			return Color(0.2, 0.3, 0.2, 1.0)  # Dark green-gray
		LocationType.DESERT:
			return Color(0.9, 0.7, 0.4, 1.0)  # Sandy
		LocationType.GLACIER:
			return Color(0.8, 0.9, 1.0, 1.0)  # Ice blue
		LocationType.MOUNTAIN:
			return Color(0.5, 0.5, 0.6, 1.0)  # Gray
		LocationType.VOLCANO:
			return Color(0.6, 0.2, 0.1, 1.0)  # Dark red
		LocationType.CAVE:
			return Color(0.2, 0.2, 0.2, 1.0)  # Dark gray
		LocationType.DRAGON_LAIR:
			return Color(0.4, 0.1, 0.1, 1.0)  # Dark red
		_:
			return Color(0.5, 0.5, 0.5, 1.0)

func _load_challenges() -> void:
	# For now, create sample challenges
	# Later these will be loaded from resources or generated
	var sample_challenge = Challenge.new()
	sample_challenge.title = "Встреча с бандитами"
	sample_challenge.description = "На лесной тропе вас окружили бандиты. Они требуют отдать все ценности."
	sample_challenge.difficulty = 3
	
	var option1 = ChallengeOption.new()
	option1.text = "Откупиться золотом (-5 золота)"
	option1.requirements = {"gold": 5}
	option1.consequences = {"gold": -5}
	
	var option2 = ChallengeOption.new()
	option2.text = "Сражаться (-1 здоровье)"
	option2.requirements = {}
	option2.consequences = {"health": -1}
	
	var option3 = ChallengeOption.new()
	option3.text = "Использовать меч"
	option3.requirements = {"item": "sword"}
	option3.consequences = {"item_lost": "sword", "gold": 3}
	
	sample_challenge.options = [option1, option2, option3]
	challenges.append(sample_challenge)

func _show_current_challenge() -> void:
	if current_challenge_index >= challenges.size():
		_complete_location()
		return
	
	var challenge = challenges[current_challenge_index]
	_display_challenge(challenge)

func _display_challenge(challenge: Challenge) -> void:
	# Clear previous UI
	for child in challenge_container.get_children():
		child.queue_free()
	
	# Create challenge UI
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	challenge_container.add_child(vbox)
	
	# Title
	var title_label = Label.new()
	title_label.text = challenge.title
	title_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title_label)
	
	# Description
	var desc_label = Label.new()
	desc_label.text = challenge.description
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_label)
	
	# Options
	var options_container = VBoxContainer.new()
	options_container.add_theme_constant_override("separation", 10)
	vbox.add_child(options_container)
	
	for i in range(challenge.options.size()):
		var option = challenge.options[i]
		if _can_select_option(option):
			var button = Button.new()
			button.text = option.text
			button.pressed.connect(_on_option_selected.bind(i))
			options_container.add_child(button)

func _can_select_option(option: ChallengeOption) -> bool:
	# Check if player meets requirements
	# For now, always return true
	return true

func _on_option_selected(option_index: int) -> void:
	var challenge = challenges[current_challenge_index]
	var option = challenge.options[option_index]
	
	# Apply consequences
	var result = {
		"challenge": challenge.title,
		"option_chosen": option.text,
		"consequences": option.consequences
	}
	
	challenge_completed.emit(result)
	
	# Move to next challenge
	current_challenge_index += 1
	_show_current_challenge()

func _complete_location() -> void:
	location_state.completed = true
	GameState.save_game()
	
	if not next_location_path.is_empty():
		get_tree().change_scene_to_file(next_location_path)
	else:
		location_completed.emit()

class LocationState extends Resource:
	@export var completed: bool = false
	@export var challenges_completed: int = 0
	@export var items_found: Array[String] = []

class Challenge extends Resource:
	@export var title: String
	@export var description: String
	@export var difficulty: int = 1
	@export var options: Array[ChallengeOption] = []

class ChallengeOption extends Resource:
	@export var text: String
	@export var requirements: Dictionary = {}  # e.g., {"gold": 5, "item": "sword"}
	@export var consequences: Dictionary = {}  # e.g., {"gold": -5, "health": -1}