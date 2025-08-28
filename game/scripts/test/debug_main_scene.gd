extends Node

# Отладочный скрипт для проверки загрузки main.tscn
var timer = 0.0
var phase = 0

func _ready():
	print("[DEBUG] Starting debug of main scene loading...")
	print("[DEBUG] Attempting to load res://game/scenes/main.tscn")
	
	# Попробуем загрузить сцену без смены
	var main_scene = load("res://game/scenes/main.tscn")
	if main_scene:
		print("[DEBUG] Scene resource loaded successfully")
		
		# Попробуем создать экземпляр
		print("[DEBUG] Instantiating scene...")
		var instance = main_scene.instantiate()
		
		if instance:
			print("[DEBUG] Scene instantiated successfully")
			print("[DEBUG] Root node: " + instance.name + " [" + instance.get_class() + "]")
			
			# Проверим дочерние узлы
			print("[DEBUG] Children:")
			for child in instance.get_children():
				print("  - " + child.name + " [" + child.get_class() + "]")
				if child.has_method("_ready"):
					print("    Has _ready method")
				if child.get_script():
					print("    Has script: " + child.get_script().resource_path)
			
			# Проверим GameManager
			if instance.has_method("_init"):
				print("[DEBUG] Root has _init method")
			if instance.has_method("_ready"):  
				print("[DEBUG] Root has _ready method")
			if instance.get_script():
				print("[DEBUG] Root script: " + instance.get_script().resource_path)
			
			# Попробуем добавить в дерево
			print("[DEBUG] Adding to scene tree...")
			get_tree().root.add_child(instance)
			print("[DEBUG] Added to scene tree")
			
			# Подождём и проверим состояние
			await get_tree().create_timer(2.0).timeout
			print("[DEBUG] After 2 seconds - checking state...")
			
			var ui_controller = instance
			if ui_controller.get_script():
				print("[DEBUG] UI Controller script is attached")
				
				# Проверим GameManager
				if "game_manager" in ui_controller:
					print("[DEBUG] game_manager property exists")
					var gm = ui_controller.get("game_manager")
					if gm:
						print("[DEBUG] GameManager instance exists: " + str(gm))
						if gm.has_method("start_new_game"):
							print("[DEBUG] GameManager has start_new_game method")
					else:
						print("[DEBUG] ERROR: game_manager is null!")
			
			instance.queue_free()
		else:
			print("[DEBUG] ERROR: Failed to instantiate scene")
	else:
		print("[DEBUG] ERROR: Failed to load scene resource")
	
	print("[DEBUG] Test completed")
	get_tree().quit()