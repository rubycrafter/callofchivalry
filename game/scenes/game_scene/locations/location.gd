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
	# Load challenges based on location type
	var challenge_dir = _get_challenge_directory()
	var available_challenges = _load_challenge_resources(challenge_dir)
	
	if available_challenges.is_empty():
		# Fallback to creating a sample challenge if no resources found
		_create_sample_challenge()
		return
	
	# Select random challenges (1-3) with total difficulty 5-10
	var num_challenges = randi_range(1, 3)
	var target_difficulty = randi_range(5, 10)
	challenges = _select_challenges(available_challenges, num_challenges, target_difficulty)

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
			button.text = option.get_formatted_text()
			button.pressed.connect(_on_option_selected.bind(i))
			options_container.add_child(button)

func _can_select_option(option: ChallengeOption) -> bool:
	# Get knight state from GameState or create mock state for now
	var knight_state = _get_knight_state()
	return option.can_select(knight_state)

func _on_option_selected(option_index: int) -> void:
	var challenge = challenges[current_challenge_index]
	var option = challenge.options[option_index]
	
	# Apply consequences to knight state
	var knight_state = _get_knight_state()
	var new_state = option.apply_consequences(knight_state)
	_update_knight_state(new_state)
	
	# Create result for signal
	var result = {
		"challenge": challenge.title,
		"option_chosen": option.text,
		"success_message": option.success_message,
		"coins_change": option.coins_change - option.coins_required,
		"health_change": option.health_change,
		"reward_coins": option.reward_coins,
		"reward_item": option.reward_item
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

func _get_challenge_directory() -> String:
	match location_type:
		LocationType.FOREST:
			return "res://game/resources/challenges/forest/"
		LocationType.STEPPE:
			return "res://game/resources/challenges/steppe/"
		LocationType.TUNDRA:
			return "res://game/resources/challenges/tundra/"
		_:
			return ""

func _load_challenge_resources(dir_path: String) -> Array[Challenge]:
	var loaded_challenges: Array[Challenge] = []
	
	if dir_path == "":
		return loaded_challenges
	
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var resource = load(dir_path + file_name)
				if resource is Challenge:
					loaded_challenges.append(resource)
			file_name = dir.get_next()
	
	return loaded_challenges

func _select_challenges(available: Array[Challenge], count: int, target_difficulty: int) -> Array[Challenge]:
	var selected: Array[Challenge] = []
	var remaining_difficulty = target_difficulty
	
	# Shuffle available challenges
	available.shuffle()
	
	for challenge in available:
		if selected.size() >= count:
			break
		if challenge.difficulty <= remaining_difficulty:
			selected.append(challenge)
			remaining_difficulty -= challenge.difficulty
	
	return selected

func _create_sample_challenge() -> void:
	# Fallback sample challenge if no resources found
	var sample = Challenge.new()
	sample.title = "Препятствие"
	sample.description = "Вы столкнулись с препятствием на пути."
	sample.difficulty = 2
	
	var option = ChallengeOption.new()
	option.text = "Преодолеть препятствие"
	option.success_message = "Вы успешно преодолели препятствие."
	sample.options = [option]
	
	challenges.append(sample)

func _get_knight_state() -> Dictionary:
	# Get knight state from GameState or create mock state
	# This will be properly integrated with the Knight system later
	return {
		"health": 3,
		"coins": 5,
		"has_horse": true,
		"inventory": ["Меч", "Щит", "Провизия"]
	}

func _update_knight_state(new_state: Dictionary) -> void:
	# Update knight state in GameState
	# This will be properly integrated with the Knight system later
	pass

class LocationState extends Resource:
	@export var completed: bool = false
	@export var challenges_completed: int = 0
	@export var items_found: Array[String] = []