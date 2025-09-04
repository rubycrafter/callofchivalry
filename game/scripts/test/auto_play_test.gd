extends Node

# Автоматический тест игрового цикла
signal test_completed(success: bool, log: Array)

var test_log = []
var current_step = ""
var test_timer: Timer

func _ready():
	test_timer = Timer.new()
	add_child(test_timer)
	test_timer.timeout.connect(_run_next_step)
	test_timer.wait_time = 0.5
	test_timer.one_shot = false
	
	# Запускаем тестирование через 1 секунду
	await get_tree().create_timer(1.0).timeout
	start_test()

func log_message(msg: String):
	var timestamp = Time.get_time_string_from_system()
	var log_entry = "%s: %s" % [timestamp, msg]
	test_log.append(log_entry)
	print(log_entry)

func start_test():
	log_message("Starting automated game test")
	current_step = "menu"
	test_timer.start()

func _run_next_step():
	match current_step:
		"menu":
			test_main_menu()
		"new_game":
			test_new_game()
		"location_select":
			test_location_selection()
		"challenge":
			test_challenge()
		"complete":
			complete_test(true)
		"error":
			complete_test(false)

func test_main_menu():
	log_message("Testing main menu...")
	
	# Проверяем наличие главного меню
	var menu = get_tree().get_nodes_in_group("main_menu")
	if menu.is_empty():
		log_message("Main menu not found - searching for button")
		# Ищем кнопку New Game
		var buttons = find_nodes_by_text("New Game")
		if not buttons.is_empty():
			log_message("Found New Game button, clicking...")
			buttons[0].pressed.emit()
			current_step = "new_game"
		else:
			log_message("ERROR: New Game button not found")
			current_step = "error"
	else:
		log_message("Main menu found")
		current_step = "new_game"

func test_new_game():
	log_message("Starting new game...")
	
	# Проверяем загрузилась ли игровая сцена
	var game_scene = get_node_or_null("/root/CallOfChivalryGame")
	if game_scene:
		log_message("Game scene loaded successfully")
		current_step = "location_select"
	else:
		log_message("Game scene not loaded yet, waiting...")

func test_location_selection():
	log_message("Testing location selection...")
	
	var location_screen = get_node_or_null("/root/CallOfChivalryGame/UILayer/LocationSelectionScreen")
	if location_screen and location_screen.visible:
		log_message("Location selection screen is visible")
		# Выбираем первую локацию
		await get_tree().create_timer(0.5).timeout
		if location_screen.has_signal("location_selected"):
			location_screen.location_selected.emit(0)
			log_message("Selected first location")
			current_step = "challenge"
	else:
		log_message("Location selection screen not visible yet")

func test_challenge():
	log_message("Testing challenge screen...")
	
	var challenge_screen = get_node_or_null("/root/CallOfChivalryGame/UILayer/ChallengeScreen")
	if challenge_screen and challenge_screen.visible:
		log_message("Challenge screen is visible")
		# Выбираем первое действие
		await get_tree().create_timer(0.5).timeout
		if challenge_screen.has_signal("action_selected"):
			challenge_screen.action_selected.emit(0)
			log_message("Selected first action")
			current_step = "complete"
	else:
		log_message("Challenge screen not visible yet")

func find_nodes_by_text(text: String) -> Array:
	var result = []
	var all_nodes = get_tree().get_nodes_in_group("buttons")
	if all_nodes.is_empty():
		all_nodes = get_all_nodes_recursive(get_tree().root)
	
	for node in all_nodes:
		if node is Button and node.text == text:
			result.append(node)
	
	return result

func get_all_nodes_recursive(node: Node) -> Array:
	var result = [node]
	for child in node.get_children():
		result.append_array(get_all_nodes_recursive(child))
	return result

func complete_test(success: bool):
	test_timer.stop()
	if success:
		log_message("TEST PASSED: Game cycle completed successfully")
	else:
		log_message("TEST FAILED: Error during game cycle")
	
	test_completed.emit(success, test_log)
	
	# Выводим полный лог
	print("\n=== TEST LOG ===")
	for entry in test_log:
		print(entry)
	print("================\n")
	
	# Завершаем через 1 секунду
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()