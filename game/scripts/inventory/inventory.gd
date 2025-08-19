extends Node
class_name Inventory

signal item_added(item: Item, slot: Vector2i)
signal item_removed(item: Item, slot: Vector2i)
signal weight_changed(current_weight: float)

@export var grid_size: Vector2i = Vector2i(10, 10)
@export var max_weight: float = 50.0

var items: Dictionary = {}
var current_weight: float = 0.0

func _ready():
	pass

func can_add_item(item: Item, position: Vector2i) -> bool:
	if not is_position_valid(position, item.size):
		return false
	
	if current_weight + item.weight > max_weight:
		return false
	
	if is_space_occupied(position, item.size):
		return false
	
	return true

func add_item(item: Item, position: Vector2i) -> bool:
	if not can_add_item(item, position):
		return false
	
	items[position] = item
	current_weight += item.weight
	item_added.emit(item, position)
	weight_changed.emit(current_weight)
	return true

func remove_item(position: Vector2i) -> Item:
	if not items.has(position):
		return null
	
	var item = items[position]
	items.erase(position)
	current_weight -= item.weight
	item_removed.emit(item, position)
	weight_changed.emit(current_weight)
	return item

func is_position_valid(position: Vector2i, size: Vector2i) -> bool:
	if position.x < 0 or position.y < 0:
		return false
	if position.x + size.x > grid_size.x:
		return false
	if position.y + size.y > grid_size.y:
		return false
	return true

func is_space_occupied(position: Vector2i, size: Vector2i) -> bool:
	for x in range(position.x, position.x + size.x):
		for y in range(position.y, position.y + size.y):
			var check_pos = Vector2i(x, y)
			for item_pos in items:
				var item = items[item_pos]
				if x >= item_pos.x and x < item_pos.x + item.size.x:
					if y >= item_pos.y and y < item_pos.y + item.size.y:
						return true
	return false

func find_free_slot(item_size: Vector2i) -> Vector2i:
	for y in range(grid_size.y - item_size.y + 1):
		for x in range(grid_size.x - item_size.x + 1):
			var pos = Vector2i(x, y)
			if not is_space_occupied(pos, item_size):
				return pos
	return Vector2i(-1, -1)

func get_all_items() -> Array[Item]:
	return items.values()

func clear():
	items.clear()
	current_weight = 0.0
	weight_changed.emit(current_weight)

func save_data() -> Dictionary:
	var data = {}
	for pos in items:
		data[str(pos)] = items[pos].resource_path
	return data

func load_data(data: Dictionary):
	clear()
	for pos_str in data:
		var pos = str_to_var(pos_str)
		var item_path = data[pos_str]
		var item = load(item_path)
		add_item(item, pos)
