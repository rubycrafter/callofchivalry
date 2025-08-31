extends Item
class_name ConsumableItem

enum EffectType {
	HEAL,
	RESTORE_STAMINA,
	BUFF,
	UTILITY
}

@export var effect_type: EffectType = EffectType.HEAL
@export var effect_value: int = 1
@export var uses: int = 1

var current_uses: int

func _init():
	item_type = ItemType.CONSUMABLE
	consumable = true

func _ready():
	current_uses = uses

func use() -> Dictionary:
	if current_uses <= 0:
		return {"consumed": true, "effect": null}
	
	current_uses -= 1
	
	var result = {
		"consumed": current_uses <= 0,
		"effect_type": effect_type,
		"effect_value": effect_value
	}
	
	return result

func get_remaining_uses() -> int:
	return current_uses