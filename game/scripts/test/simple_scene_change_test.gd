extends Node

# Простейший тест смены сцены
func _ready():
	print("[SIMPLE TEST] Starting scene change test")
	
	# Подождём немного
	await get_tree().create_timer(2.0).timeout
	
	print("[SIMPLE TEST] Attempting to change scene to minimal_ui.tscn")
	
	# Попробуем сменить сцену на минимальную без скриптов
	var result = get_tree().change_scene_to_file("res://game/scenes/test/minimal_ui.tscn")
	
	print("[SIMPLE TEST] Scene change result: " + str(result))
	
	# Подождём ещё немного
	await get_tree().create_timer(2.0).timeout
	
	print("[SIMPLE TEST] Test completed, quitting")
	get_tree().quit()