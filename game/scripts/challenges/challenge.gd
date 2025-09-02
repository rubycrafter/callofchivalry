extends Resource
class_name Challenge

enum ActionType {
	USE_ITEM,
	SPEND_COINS,
	TAKE_DAMAGE,
	ESCAPE_ON_HORSE,
	FIGHT,
	NEGOTIATE,
	SNEAK,
	WAIT,
	CUSTOM
}

@export var title: String = "Испытание"
@export var description: String = ""
@export var difficulty: int = 1
@export var options: Array[ChallengeOption] = []

func get_available_options(knight_state: Dictionary) -> Array[ChallengeOption]:
	var available: Array[ChallengeOption] = []
	for option in options:
		if option.can_select(knight_state):
			available.append(option)
	return available

func select_random_challenges(count: int, target_difficulty: int) -> Array[Challenge]:
	var selected: Array[Challenge] = []
	var remaining_difficulty = target_difficulty
	
	while selected.size() < count and remaining_difficulty > 0:
		var challenge = Challenge.new()
		challenge.difficulty = min(remaining_difficulty, randi_range(1, 5))
		remaining_difficulty -= challenge.difficulty
		selected.append(challenge)
	
	return selected