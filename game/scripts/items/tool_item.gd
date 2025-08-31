extends Item
class_name ToolItem

@export var tool_type: String = ""
@export var uses: int = -1

var current_uses: int

func _init():
	item_type = ItemType.TOOL
	consumable = false

func _ready():
	current_uses = uses if uses > 0 else -1

func use() -> Dictionary:
	if uses > 0:
		current_uses -= 1
		if current_uses <= 0:
			return {"consumed": true, "tool_type": tool_type}
	
	return {"consumed": false, "tool_type": tool_type}

func get_remaining_uses() -> int:
	return current_uses if uses > 0 else -1

func can_use_for(purpose: String) -> bool:
	return tool_type == purpose and (uses < 0 or current_uses > 0)