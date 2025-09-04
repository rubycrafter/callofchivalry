extends Node

# Полный автоматический тест игрового цикла через headless Godot
var test_steps = []
var errors = []
var current_step = 0

func _ready():
	print("\n" + ("=" * 50))
	print("FULL GAME CYCLE TEST")
	print(("=" * 50) + "\n")
	
	run_test()

func run_test():
	# Шаг 1: Проверяем главную сцену
	test_main_menu()
	
	# Шаг 2: Запускаем новую игру
	test_new_game()
	
	# Шаг 3: Проверяем выбор локации
	test_location_selection()
	
	# Шаг 4: Проверяем экран испытания
	test_challenge_screen()
	
	# Шаг 5: Завершаем тест
	finish_test()

func test_main_menu():
	print("[TEST] Checking main menu...")
	
	# Симулируем загрузку главного меню
	var menu_scene = load("res://game/scenes/menus/main_menu/main_menu_with_animations.tscn")
	if menu_scene:
		test_steps.append("✓ Main menu scene loaded")
		print("  ✓ Main menu scene loaded")
	else:
		errors.append("✗ Failed to load main menu")
		print("  ✗ Failed to load main menu")

func test_new_game():
	print("[TEST] Starting new game...")
	
	# Загружаем игровую сцену
	var game_scene = load("res://game/scenes/game_scene/levels/call_of_chivalry_game.tscn")
	if game_scene:
		var game = game_scene.instantiate()
		add_child(game)
		
		# Ждем инициализации
		await get_tree().create_timer(0.1).timeout
		
		if game.game_manager:
			test_steps.append("✓ GameManager created")
			print("  ✓ GameManager created")
			
			# Проверяем начальное состояние
			if game.game_manager.knight:
				test_steps.append("✓ Knight initialized (Health: %d, Coins: %d)" % 
					[game.game_manager.knight.current_health, game.game_manager.knight.coins])
				print("  ✓ Knight initialized")
			else:
				errors.append("✗ Knight not initialized")
				print("  ✗ Knight not initialized")
		else:
			errors.append("✗ GameManager not created")
			print("  ✗ GameManager not created")
			
		game.queue_free()
	else:
		errors.append("✗ Failed to load game scene")
		print("  ✗ Failed to load game scene")

func test_location_selection():
	print("[TEST] Testing location selection...")
	
	# Создаем GameManager для теста
	var GameManager = load("res://game/scripts/game_manager/game_manager.gd")
	var gm = GameManager.new()
	add_child(gm)
	
	# Запускаем новую игру
	gm.start_new_game()
	
	# Проверяем доступные локации
	var locations = gm.game_map.get_initial_location_choices()
	if locations.size() == 3:
		test_steps.append("✓ Initial locations available: %d" % locations.size())
		print("  ✓ Initial locations available: %d" % locations.size())
		
		# Выбираем первую локацию
		gm.select_starting_location(0)
		
		if gm.current_location:
			test_steps.append("✓ Location selected: %s" % gm.current_location.name)
			print("  ✓ Location selected: %s" % gm.current_location.name)
		else:
			errors.append("✗ Failed to select location")
			print("  ✗ Failed to select location")
	else:
		errors.append("✗ Wrong number of initial locations: %d" % locations.size())
		print("  ✗ Wrong number of initial locations: %d" % locations.size())
	
	gm.queue_free()

func test_challenge_screen():
	print("[TEST] Testing challenge system...")
	
	# Проверяем загрузку испытаний
	var ForestLocation = load("res://game/scripts/locations/forest_location.gd")
	var forest = ForestLocation.new()
	
	var challenges = forest.select_challenges()
	if challenges.size() > 0:
		test_steps.append("✓ Challenges loaded: %d" % challenges.size())
		print("  ✓ Challenges loaded: %d" % challenges.size())
		
		var first_challenge = challenges[0]
		if first_challenge.title != "":
			test_steps.append("✓ Challenge has title: %s" % first_challenge.title)
			print("  ✓ Challenge has title: %s" % first_challenge.title)
		else:
			errors.append("✗ Challenge has no title")
			print("  ✗ Challenge has no title")
	else:
		errors.append("✗ No challenges loaded")
		print("  ✗ No challenges loaded")
	
	forest.queue_free()

func finish_test():
	print("\n" + ("=" * 50))
	print("TEST RESULTS")
	print("=" * 50)
	
	print("\nSuccessful steps: %d" % test_steps.size())
	for step in test_steps:
		print("  " + step)
	
	if errors.size() > 0:
		print("\nErrors: %d" % errors.size())
		for error in errors:
			print("  " + error)
		print("\n❌ TEST FAILED")
	else:
		print("\n✅ ALL TESTS PASSED!")
	
	print(("=" * 50) + "\n")
	
	# Завершаем через секунду
	await get_tree().create_timer(1.0).timeout
	get_tree().quit(0 if errors.size() == 0 else 1)