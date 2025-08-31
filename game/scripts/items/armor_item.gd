extends Item
class_name ArmorItem

@export var defense: int = 1
@export var durability: int = -1

var current_durability: int

func _init():
	item_type = ItemType.ARMOR
	consumable = false
	current_durability = durability

func absorb_damage(damage: int) -> int:
	var absorbed = min(damage, defense)
	
	if durability > 0:
		current_durability -= 1
		if current_durability <= 0:
			return 0
	
	return absorbed

func is_broken() -> bool:
	return durability > 0 and current_durability <= 0