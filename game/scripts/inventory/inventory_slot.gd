extends Panel
class_name InventorySlot

signal slot_clicked(slot: InventorySlot)
signal item_dropped(item: Item)

@export var grid_position: Vector2i
var item: Item = null
var item_icon: TextureRect

func _ready():
	custom_minimum_size = Vector2(64, 64)
	
	item_icon = TextureRect.new()
	item_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(item_icon)
	
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			slot_clicked.emit(self)

func set_item(new_item: Item):
	item = new_item
	if item:
		item_icon.texture = item.icon
		item_icon.visible = true
		tooltip_text = "%s\nWeight: %.1f kg\nSize: %dx%d" % [item.name, item.weight, item.size.x, item.size.y]
		if item.description:
			tooltip_text += "\n%s" % item.description
	else:
		item_icon.visible = false
		tooltip_text = ""

func clear():
	set_item(null)

func _can_drop_data(position: Vector2, data) -> bool:
	if not data.has("item"):
		return false
	return item == null

func _drop_data(position: Vector2, data):
	if data.has("item"):
		item_dropped.emit(data["item"])
