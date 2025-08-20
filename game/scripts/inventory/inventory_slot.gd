extends Panel
class_name InventorySlot

signal slot_clicked(slot: InventorySlot)
signal item_dropped(item: Item)

@export var grid_position: Vector2i
var item: Item = null
var item_icon: TextureRect
var occupied_by: Vector2i = Vector2i(-1, -1)  # Position of the item that occupies this slot

func _ready():
	custom_minimum_size = Vector2(64, 64)
	
	item_icon = TextureRect.new()
	item_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item_icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(item_icon)
	
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			slot_clicked.emit(self)

func set_item(new_item: Item):
	item = new_item
	occupied_by = Vector2i(-1, -1)
	if item:
		item_icon.texture = item.icon
		item_icon.visible = true
		tooltip_text = "%s\nWeight: %.1f kg\nSize: %dx%d" % [item.name, item.weight, item.size.x, item.size.y]
		if item.description:
			tooltip_text += "\n%s" % item.description
		
		# Update style for item slot
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.25, 0.25, 0.25, 0.9)
		style.border_color = Color(0.6, 0.6, 0.6)
		style.set_border_width_all(2)
		add_theme_stylebox_override("panel", style)
	else:
		item_icon.visible = false
		tooltip_text = ""
		
		# Reset style for empty slot
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
		style.border_color = Color(0.4, 0.4, 0.4)
		style.set_border_width_all(1)
		add_theme_stylebox_override("panel", style)

func clear():
	set_item(null)
	occupied_by = Vector2i(-1, -1)

func set_occupied_by(main_position: Vector2i):
	occupied_by = main_position
	item_icon.visible = false
	tooltip_text = "Occupied"
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.3, 0.3, 0.3, 0.8)
	style.border_color = Color(0.5, 0.5, 0.5)
	style.set_border_width_all(1)
	add_theme_stylebox_override("panel", style)

func clear_occupied():
	occupied_by = Vector2i(-1, -1)
	item_icon.visible = false
	tooltip_text = ""
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	style.border_color = Color(0.4, 0.4, 0.4)
	style.set_border_width_all(1)
	add_theme_stylebox_override("panel", style)

func is_occupied() -> bool:
	return occupied_by.x >= 0

func get_main_position() -> Vector2i:
	if is_occupied():
		return occupied_by
	elif item:
		return grid_position
	return Vector2i(-1, -1)

func _can_drop_data(position: Vector2, data) -> bool:
	if not data.has("item"):
		return false
	return item == null and not is_occupied()

func _drop_data(position: Vector2, data):
	if data.has("item"):
		item_dropped.emit(data["item"])
