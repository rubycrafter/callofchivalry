extends Resource
class_name Item

@export var name: String = "Item"
@export var description: String = ""
@export var icon: Texture2D
@export var weight: float = 1.0
@export var size: Vector2i = Vector2i(1, 1)
@export var consumable: bool = true
@export var stackable: bool = false
@export var max_stack: int = 1
@export var value: int = 0

enum ItemType {
	WEAPON,
	ARMOR,
	CONSUMABLE,
	TOOL,
	MISC
}

@export var item_type: ItemType = ItemType.MISC

func can_use() -> bool:
	return true

func use() -> Dictionary:
	return {"consumed": false}
