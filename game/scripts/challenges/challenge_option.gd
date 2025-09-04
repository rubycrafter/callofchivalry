extends Resource
class_name ChallengeOption

@export var text: String = "Действие"
@export var action_type: Challenge.ActionType = Challenge.ActionType.NEGOTIATE
@export var success_message: String = "Действие выполнено!"
@export var failure_message: String = "Действие не удалось!"

@export_group("Requirements")
@export var coins_required: int = 0
@export var health_required: int = 0
@export var item_required: String = ""
@export var horse_required: bool = false

@export_group("Consequences")
@export var coins_change: int = 0
@export var health_change: int = 0
@export var item_consumed: String = ""
@export var horse_lost: bool = false

@export_group("Rewards")
@export var reward_coins: int = 0
@export var reward_item: String = ""

func can_select(knight_state: Dictionary) -> bool:
	if coins_required > 0 and knight_state.get("coins", 0) < coins_required:
		return false
	
	if health_required > 0 and knight_state.get("health", 0) < health_required:
		return false
	
	if item_required != "" and not knight_state.get("inventory", []).has(item_required):
		return false
	
	if horse_required and not knight_state.get("has_horse", false):
		return false
	
	return true

func apply_consequences(knight_state: Dictionary) -> Dictionary:
	var new_state = knight_state.duplicate(true)
	
	new_state["coins"] = max(0, new_state.get("coins", 0) + coins_change - coins_required)
	new_state["health"] = max(0, new_state.get("health", 3) + health_change)
	
	if item_consumed != "" and new_state.has("inventory"):
		new_state["inventory"].erase(item_consumed)
	
	if horse_lost:
		new_state["has_horse"] = false
	
	if reward_coins > 0:
		new_state["coins"] = new_state.get("coins", 0) + reward_coins
	
	if reward_item != "" and new_state.has("inventory"):
		new_state["inventory"].append(reward_item)
	
	return new_state

func get_formatted_text() -> String:
	var formatted = text
	
	if coins_required > 0:
		formatted += " [-%d монет]" % coins_required
	elif coins_change < 0:
		formatted += " [%d монет]" % abs(coins_change)
	
	if health_change < 0:
		formatted += " [-%d здоровья]" % abs(health_change)
	
	if item_required != "":
		formatted += " [Требуется: %s]" % item_required
	
	if horse_required:
		formatted += " [Требуется конь]"
	
	return formatted