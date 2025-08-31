extends Control

signal location_selected(index: int)
signal back_pressed()

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var locations_container: HBoxContainer = $VBoxContainer/LocationsContainer
@onready var back_button: Button = $VBoxContainer/BackButton

var location_buttons: Array[Button] = []
var locations: Array = []

func _ready() -> void:
	_setup_back_button()

func _setup_back_button() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

func setup_locations(available_locations: Array, is_initial: bool = true) -> void:
	locations = available_locations
	
	# Update title
	if title_label:
		if is_initial:
			title_label.text = "Выберите начальную локацию"
		else:
			title_label.text = "Выберите следующую локацию"
	
	# Clear existing buttons
	for button in location_buttons:
		button.queue_free()
	location_buttons.clear()
	
	# Create new buttons
	for i in range(locations.size()):
		var location = locations[i]
		var button = Button.new()
		button.text = location.name
		button.custom_minimum_size = Vector2(200, 80)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Add description as tooltip
		button.tooltip_text = location.description
		
		# Connect signal with index
		button.pressed.connect(_on_location_button_pressed.bind(i))
		
		locations_container.add_child(button)
		location_buttons.append(button)

func _on_location_button_pressed(index: int) -> void:
	location_selected.emit(index)

func _on_back_pressed() -> void:
	back_pressed.emit()

func show_screen() -> void:
	show()

func hide_screen() -> void:
	hide()
