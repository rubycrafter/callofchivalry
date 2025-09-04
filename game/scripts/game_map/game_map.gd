class_name GameMap
extends Resource

signal location_selected(location: Location)
signal journey_completed()

const ForestLocation = preload("res://game/scripts/locations/forest_location.gd")
const SteppeLocation = preload("res://game/scripts/locations/steppe_location.gd")
const TundraLocation = preload("res://game/scripts/locations/tundra_location.gd")
const SwampLocation = preload("res://game/scripts/locations/swamp_location.gd")
const DesertLocation = preload("res://game/scripts/locations/desert_location.gd")
const GlacierLocation = preload("res://game/scripts/locations/glacier_location.gd")
const MountainLocation = preload("res://game/scripts/locations/mountain_location.gd")
const VolcanoLocation = preload("res://game/scripts/locations/volcano_location.gd")
const CaveLocation = preload("res://game/scripts/locations/cave_location.gd")
const DragonLairLocation = preload("res://game/scripts/locations/dragon_lair_location.gd")

enum MapRow { ROW_1, ROW_2, ROW_3, FINAL }
enum LocationPosition { LEFT, CENTER, RIGHT }

@export var current_row: MapRow = MapRow.ROW_1
@export var current_position: LocationPosition = LocationPosition.CENTER
@export var visited_locations: Array[String] = []
@export var completed_locations: Array[String] = []

var map_structure: Dictionary = {
	MapRow.ROW_1: {
		LocationPosition.LEFT: ForestLocation,
		LocationPosition.CENTER: SteppeLocation,
		LocationPosition.RIGHT: TundraLocation
	},
	MapRow.ROW_2: {
		LocationPosition.LEFT: SwampLocation,
		LocationPosition.CENTER: DesertLocation,
		LocationPosition.RIGHT: GlacierLocation
	},
	MapRow.ROW_3: {
		LocationPosition.LEFT: MountainLocation,
		LocationPosition.CENTER: VolcanoLocation,
		LocationPosition.RIGHT: CaveLocation
	},
	MapRow.FINAL: {
		LocationPosition.CENTER: DragonLairLocation
	}
}

func _init() -> void:
	current_row = MapRow.ROW_1
	current_position = LocationPosition.CENTER
	visited_locations = []
	completed_locations = []

func get_current_location() -> Location:
	if current_row == MapRow.FINAL:
		return DragonLairLocation.new()
	
	var row_locations = map_structure.get(current_row, {})
	var location_class = row_locations.get(current_position)
	
	if location_class:
		return location_class.new()
	
	return null

func get_available_next_locations() -> Array[Location]:
	var available: Array[Location] = []
	
	if current_row == MapRow.FINAL:
		return available
	
	if current_row == MapRow.ROW_3:
		available.append(DragonLairLocation.new())
		return available
	
	var next_row = current_row + 1
	var next_positions = _get_available_positions_from(current_position)
	
	for pos in next_positions:
		var row_locations = map_structure.get(next_row, {})
		var location_class = row_locations.get(pos)
		if location_class:
			available.append(location_class.new())
	
	return available

func _get_available_positions_from(position: LocationPosition) -> Array[LocationPosition]:
	match position:
		LocationPosition.LEFT:
			return [LocationPosition.LEFT, LocationPosition.CENTER]
		LocationPosition.CENTER:
			return [LocationPosition.LEFT, LocationPosition.CENTER, LocationPosition.RIGHT]
		LocationPosition.RIGHT:
			return [LocationPosition.CENTER, LocationPosition.RIGHT]
		_:
			return []

func move_to_location(location: Location) -> bool:
	var available = get_available_next_locations()
	
	for avail_location in available:
		if avail_location.name == location.name:
			var previous_location = get_current_location()
			if previous_location and not previous_location.name in completed_locations:
				completed_locations.append(previous_location.name)
			
			if location.name == "Логово дракона":
				current_row = MapRow.FINAL
				current_position = LocationPosition.CENTER
			else:
				current_row = current_row + 1
				current_position = _get_position_for_location(location.name, current_row)
			
			if not location.name in visited_locations:
				visited_locations.append(location.name)
			
			location_selected.emit(location)
			
			if current_row == MapRow.FINAL:
				journey_completed.emit()
			
			return true
	
	return false

func _get_position_for_location(location_name: String, row: MapRow) -> LocationPosition:
	var row_locations = map_structure.get(row, {})
	
	for pos in row_locations:
		var location_class = row_locations[pos]
		var temp_location = location_class.new()
		if temp_location.name == location_name:
			return pos
	
	return LocationPosition.CENTER

func can_start_journey() -> bool:
	return current_row == MapRow.ROW_1

func get_initial_location_choices() -> Array[Location]:
	if not can_start_journey():
		var empty_array: Array[Location] = []
		return empty_array
	
	var choices: Array[Location] = []
	var row_locations = map_structure.get(MapRow.ROW_1, {})
	
	for pos in row_locations:
		var location_class = row_locations[pos]
		choices.append(location_class.new())
	
	return choices

func start_journey_from(location: Location) -> bool:
	if not can_start_journey():
		return false
	
	var initial_choices = get_initial_location_choices()
	
	for choice in initial_choices:
		if choice.name == location.name:
			current_row = MapRow.ROW_1
			current_position = _get_position_for_location(location.name, MapRow.ROW_1)
			
			if not location.name in visited_locations:
				visited_locations.append(location.name)
			
			location_selected.emit(location)
			return true
	
	return false

func get_progress_percentage() -> float:
	var total_locations = 4
	var completed = completed_locations.size()
	
	if current_row == MapRow.FINAL:
		completed = 4
	
	return (completed / float(total_locations)) * 100.0

func is_journey_complete() -> bool:
	return current_row == MapRow.FINAL

func get_journey_stats() -> Dictionary:
	return {
		"visited_locations": visited_locations.size(),
		"completed_locations": completed_locations.size(),
		"current_location": get_current_location().name if get_current_location() else "None",
		"progress": get_progress_percentage(),
		"is_complete": is_journey_complete()
	}

func reset() -> void:
	current_row = MapRow.ROW_1
	current_position = LocationPosition.CENTER
	visited_locations.clear()
	completed_locations.clear()