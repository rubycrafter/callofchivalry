class_name Location
extends Resource

const Challenge = preload("res://game/scripts/challenges/challenge.gd")

@export var name: String = ""
@export var description: String = ""
@export var icon_path: String = ""
@export var challenges: Array[Challenge] = []
@export var min_challenges: int = 1
@export var max_challenges: int = 3

var selected_challenges: Array[Challenge] = []
var current_challenge_index: int = 0
var is_completed: bool = false

signal challenge_started(challenge: Challenge)
signal challenge_completed(challenge: Challenge, success: bool)
signal location_completed()

func enter_location() -> void:
	is_completed = false
	current_challenge_index = 0
	_select_challenges()
	if selected_challenges.size() > 0:
		start_next_challenge()

func _select_challenges() -> void:
	selected_challenges.clear()
	
	if challenges.is_empty():
		push_error("Location %s has no challenges!" % name)
		return
	
	var available_challenges = challenges.duplicate()
	available_challenges.shuffle()
	
	var num_challenges = randi_range(min_challenges, min(max_challenges, available_challenges.size()))
	var total_difficulty = 0
	var target_difficulty = randi_range(5, 10)
	
	for i in range(num_challenges):
		var best_challenge: Challenge = null
		var best_diff = INF
		
		for challenge in available_challenges:
			if challenge in selected_challenges:
				continue
			
			var new_total = total_difficulty + challenge.difficulty
			if new_total <= target_difficulty:
				var diff = abs(target_difficulty - new_total)
				if diff < best_diff:
					best_diff = diff
					best_challenge = challenge
		
		if best_challenge:
			selected_challenges.append(best_challenge)
			total_difficulty += best_challenge.difficulty
		elif selected_challenges.is_empty():
			selected_challenges.append(available_challenges[0])
			break
	
	print("Selected %d challenges for %s with total difficulty %d" % [selected_challenges.size(), name, total_difficulty])

func start_next_challenge() -> void:
	if current_challenge_index >= selected_challenges.size():
		complete_location()
		return
	
	var challenge = selected_challenges[current_challenge_index]
	challenge_started.emit(challenge)

func complete_current_challenge(success: bool) -> void:
	if current_challenge_index >= selected_challenges.size():
		return
	
	var challenge = selected_challenges[current_challenge_index]
	challenge_completed.emit(challenge, success)
	
	current_challenge_index += 1
	
	if current_challenge_index >= selected_challenges.size():
		complete_location()
	else:
		start_next_challenge()

func complete_location() -> void:
	is_completed = true
	location_completed.emit()
	print("Location %s completed!" % name)

func get_current_challenge() -> Challenge:
	if current_challenge_index < selected_challenges.size():
		return selected_challenges[current_challenge_index]
	return null

func get_progress() -> float:
	if selected_challenges.is_empty():
		return 0.0
	return float(current_challenge_index) / float(selected_challenges.size())

func reset() -> void:
	selected_challenges.clear()
	current_challenge_index = 0
	is_completed = false