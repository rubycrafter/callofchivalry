extends Control
class_name InventoryUI

@onready var inventory: Inventory = $Inventory
@export var slot_scene: PackedScene

@onready var grid_container: GridContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var weight_label: Label = $Panel/MarginContainer/VBoxContainer/WeightLabel
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/CloseButton

var slots: Array[InventorySlot] = []
var dragged_item: Item = null
var dragged_from_slot: Vector2i

func _ready():
	if not inventory:
		inventory = Inventory.new()
		add_child(inventory)
	
	inventory.weight_changed.connect(_on_weight_changed)
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	
	if close_button:
		close_button.pressed.connect(_on_close_pressed)
	
	_create_grid()
	_update_weight_display()

func _create_grid():
	if not grid_container:
		return
	
	grid_container.columns = inventory.grid_size.x
	
	for child in grid_container.get_children():
		child.queue_free()
	
	slots.clear()
	
	for y in range(inventory.grid_size.y):
		for x in range(inventory.grid_size.x):
			var slot = InventorySlot.new()
			slot.grid_position = Vector2i(x, y)
			slot.slot_clicked.connect(_on_slot_clicked)
			slot.item_dropped.connect(_on_item_dropped_to_slot.bind(slot))
			
			var style = StyleBoxFlat.new()
			style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
			style.border_color = Color(0.4, 0.4, 0.4)
			style.set_border_width_all(1)
			slot.add_theme_stylebox_override("panel", style)
			
			grid_container.add_child(slot)
			slots.append(slot)

func _on_weight_changed(new_weight: float):
	_update_weight_display()

func _update_weight_display():
	if weight_label:
		weight_label.text = "Weight: %.1f / %.1f kg" % [inventory.current_weight, inventory.max_weight]
		if inventory.current_weight > inventory.max_weight * 0.8:
			weight_label.modulate = Color.YELLOW
		else:
			weight_label.modulate = Color.WHITE

func _on_item_added(item: Item, position: Vector2i):
	# Set the item in the main slot
	var slot_index = position.y * inventory.grid_size.x + position.x
	if slot_index < slots.size():
		slots[slot_index].set_item(item)
	
	# Mark other slots as occupied by this item
	for y in range(item.size.y):
		for x in range(item.size.x):
			if x == 0 and y == 0:
				continue
			var occupied_index = (position.y + y) * inventory.grid_size.x + (position.x + x)
			if occupied_index < slots.size():
				slots[occupied_index].set_occupied_by(position)

func _on_item_removed(item: Item, position: Vector2i):
	# Clear the main slot
	var slot_index = position.y * inventory.grid_size.x + position.x
	if slot_index < slots.size():
		slots[slot_index].clear()
	
	# Clear other slots that were occupied by this item
	for y in range(item.size.y):
		for x in range(item.size.x):
			if x == 0 and y == 0:
				continue
			var occupied_index = (position.y + y) * inventory.grid_size.x + (position.x + x)
			if occupied_index < slots.size():
				slots[occupied_index].clear_occupied()

func _on_slot_clicked(slot: InventorySlot):
	if dragged_item:
		if not slot.is_occupied() and inventory.can_add_item(dragged_item, slot.grid_position):
			inventory.add_item(dragged_item, slot.grid_position)
			dragged_item = null
	else:
		var main_pos = slot.get_main_position()
		if main_pos.x >= 0:
			dragged_item = inventory.remove_item(main_pos)
			if dragged_item:
				dragged_from_slot = main_pos

func _on_item_dropped_to_slot(item: Item, slot: InventorySlot):
	if inventory.can_add_item(item, slot.grid_position):
		inventory.add_item(item, slot.grid_position)

func _on_close_pressed():
	hide()

func add_item_auto(item: Item) -> bool:
	var free_slot = inventory.find_free_slot(item.size)
	if free_slot.x >= 0:
		return inventory.add_item(item, free_slot)
	return false
