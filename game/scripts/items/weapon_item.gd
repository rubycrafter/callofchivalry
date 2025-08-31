extends Item
class_name WeaponItem

@export var damage: int = 1
@export var durability: int = -1
@export var attack_range: float = 1.0

var current_durability: int

func _init():
	item_type = ItemType.WEAPON
	consumable = false
	current_durability = durability

func use() -> Dictionary:
	if durability > 0:
		current_durability -= 1
		if current_durability <= 0:
			return {"consumed": true, "damage_dealt": damage}
	return {"consumed": false, "damage_dealt": damage}

func is_broken() -> bool:
	return durability > 0 and current_durability <= 0