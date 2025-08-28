class_name Challenge
extends Resource

enum ActionType {
	USE_ITEM,
	SPEND_COINS,
	TAKE_DAMAGE,
	ESCAPE_ON_HORSE,
	CUSTOM
}

@export var title: String = ""
@export var description: String = ""
@export var difficulty: int = 1
@export var image_path: String = ""

@export var actions: Array[ChallengeAction] = []

signal action_selected(action: ChallengeAction)

func get_available_actions(knight: Node) -> Array[ChallengeAction]:
	var available: Array[ChallengeAction] = []
	
	for action in actions:
		if action.is_available(knight):
			available.append(action)
	
	return available

func execute_action(action: ChallengeAction, knight: Node) -> Dictionary:
	if not action in actions:
		return {"success": false, "message": "Invalid action"}
	
	if not action.is_available(knight):
		return {"success": false, "message": "Action not available"}
	
	var result = action.execute(knight)
	action_selected.emit(action)
	return result

class ChallengeAction extends Resource:
	@export var text: String = ""
	@export var type: ActionType = ActionType.CUSTOM
	@export var item_required: String = ""
	@export var coins_required: int = 0
	@export var damage_taken: int = 0
	@export var requires_horse: bool = false
	
	@export var success_message: String = ""
	@export var failure_message: String = ""
	@export var reward_coins: int = 0
	@export var reward_item: String = ""
	
	func is_available(knight: Node) -> bool:
		match type:
			ActionType.USE_ITEM:
				return false
			ActionType.SPEND_COINS:
				return knight.can_afford(coins_required)
			ActionType.TAKE_DAMAGE:
				return knight.current_health > damage_taken
			ActionType.ESCAPE_ON_HORSE:
				return knight.has_horse
			ActionType.CUSTOM:
				return true
		return false
	
	func execute(knight: Node) -> Dictionary:
		var result = {"success": false, "message": failure_message}
		
		match type:
			ActionType.USE_ITEM:
				if false:
					result = {"success": true, "message": success_message}
			
			ActionType.SPEND_COINS:
				if knight.spend_coins(coins_required):
					result = {"success": true, "message": success_message}
			
			ActionType.TAKE_DAMAGE:
				knight.take_damage(damage_taken)
				result = {"success": true, "message": success_message}
			
			ActionType.ESCAPE_ON_HORSE:
				if requires_horse and knight.has_horse:
					knight.lose_horse()
					result = {"success": true, "message": success_message}
			
			ActionType.CUSTOM:
				result = {"success": true, "message": success_message}
		
		if result["success"]:
			if reward_coins > 0:
				knight.add_coins(reward_coins)
				result["message"] += "\nПолучено монет: %d" % reward_coins
			
			if reward_item != "" and knight.inventory:
				if false:
					result["message"] += "\nПолучен предмет: %s" % reward_item
		
		return result