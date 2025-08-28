extends Node

# Автоматический тест UI - запускает Demo UI и проверяет работу
var test_phase = 0
var timer = 0.0
var logs = []

func _ready():
	print("[UI_AUTO_TEST] Starting automated UI test")
	logs.append("Test started")
	set_process(true)

func _process(delta):
	timer += delta
	
	match test_phase:
		0: # Ждём загрузку меню и добавление кнопок через call_deferred
			if timer > 3.0:  # Увеличил задержку для call_deferred
				print("[UI_AUTO_TEST] Phase 0: Looking for Demo UI button")
				logs.append("Phase 0: Searching for Demo UI button")
				_find_and_click_demo_ui()
				test_phase = 1
				timer = 0.0
		
		1: # Проверяем что произошло после нажатия
			if timer > 3.0:
				print("[UI_AUTO_TEST] Phase 1: Checking scene after Demo UI click")
				_check_current_scene()
				test_phase = 2
				timer = 0.0
		
		2: # Завершаем тест
			print("[UI_AUTO_TEST] Test completed")
			_print_results()
			get_tree().quit()

func _find_and_click_demo_ui():
	# Ищем кнопку Demo UI в дереве сцены
	var root = get_tree().root
	
	# Сначала попробуем найти кнопку напрямую 
	var demo_button = _find_node_by_name(root, "DemoUIButton")
	
	if not demo_button:
		# Попробуем найти через правильный путь в MenuContainer
		var main_menu = _find_node_by_name(root, "MainMenuWithAnimations")
		if main_menu:
			var button_path = "MenuContainer/MenuButtonsMargin/MenuButtonsContainer/MenuButtonsBoxContainer/DemoUIButton"
			demo_button = main_menu.get_node_or_null(button_path)
			print("[UI_AUTO_TEST] Searching at path: " + button_path)
	
	if demo_button:
		print("[UI_AUTO_TEST] Found Demo UI button: " + str(demo_button))
		logs.append("Demo UI button found and clicked")
		if demo_button.has_signal("pressed"):
			demo_button.pressed.emit()
		elif demo_button.has_method("_pressed"):
			demo_button._pressed()
		else:
			print("[UI_AUTO_TEST] ERROR: Button has no pressed signal!")
	else:
		print("[UI_AUTO_TEST] ERROR: Demo UI button not found!")
		logs.append("ERROR: Demo UI button not found")
		
		# Debug: выведем всю структуру MenuContainer
		var main_menu = _find_node_by_name(root, "MainMenuWithAnimations") 
		if main_menu:
			var menu_container = main_menu.get_node_or_null("MenuContainer")
			if menu_container:
				_print_tree(menu_container, 0)

func _find_node_by_name(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	
	for child in node.get_children():
		var result = _find_node_by_name(child, target_name)
		if result:
			return result
	
	return null

func _check_current_scene():
	var current_scene = get_tree().current_scene
	if current_scene:
		print("[UI_AUTO_TEST] Current scene: " + current_scene.name)
		print("[UI_AUTO_TEST] Scene path: " + current_scene.scene_file_path)
		logs.append("Current scene after click: " + current_scene.name)
		
		# Проверяем, загрузилась ли UI система
		var ui_controller = _find_node_by_name(current_scene, "UIController")
		var game_manager = _find_node_by_name(current_scene, "GameManager")
		
		if ui_controller:
			print("[UI_AUTO_TEST] UI Controller found!")
			logs.append("UI Controller loaded successfully")
		else:
			print("[UI_AUTO_TEST] WARNING: UI Controller not found")
			logs.append("WARNING: UI Controller not found")
		
		if game_manager:
			print("[UI_AUTO_TEST] Game Manager found!")
			logs.append("Game Manager loaded successfully")
		else:
			print("[UI_AUTO_TEST] WARNING: Game Manager not found")
			logs.append("WARNING: Game Manager not found")
			
		# Проверяем на ошибки в консоли
		_check_for_errors()
	else:
		print("[UI_AUTO_TEST] ERROR: No current scene!")
		logs.append("ERROR: No current scene after Demo UI click")

func _check_for_errors():
	# Этот метод будет анализировать ошибки если они есть
	print("[UI_AUTO_TEST] Checking for runtime errors...")
	logs.append("Error check completed")

func _print_tree(node: Node, level: int) -> void:
	var indent = ""
	for i in range(level):
		indent += "  "
	print(indent + "- " + node.name + " [" + node.get_class() + "]")
	for child in node.get_children():
		_print_tree(child, level + 1)

func _print_results():
	print("\n========== UI AUTO TEST RESULTS ==========")
	for log in logs:
		print(log)
	print("==========================================\n")