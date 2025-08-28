extends Control

signal return_to_menu()
signal restart_game()

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var message_label: RichTextLabel = $VBoxContainer/MessageLabel
@onready var stats_container: VBoxContainer = $VBoxContainer/StatsPanel/VBoxContainer
@onready var menu_button: Button = $VBoxContainer/ButtonContainer/MenuButton
@onready var restart_button: Button = $VBoxContainer/ButtonContainer/RestartButton

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)

func setup_game_over(victory: bool, stats: Dictionary) -> void:
	# Set title
	if title_label:
		if victory:
			title_label.text = "ПОБЕДА!"
			title_label.modulate = Color.GOLD
		else:
			title_label.text = "ПОРАЖЕНИЕ"
			title_label.modulate = Color.RED
	
	# Set message
	if message_label:
		if victory:
			message_label.text = "[center]Вы успешно одолели дракона и завершили своё приключение!\n\nВаша слава будет жить в веках![/center]"
		else:
			message_label.text = "[center]Ваше приключение закончилось...\n\nНо каждая неудача - это урок для следующей попытки![/center]"
	
	# Display stats
	_display_stats(stats)

func _display_stats(stats: Dictionary) -> void:
	# Clear existing stats
	for child in stats_container.get_children():
		child.queue_free()
	
	# Add title
	var stats_title = Label.new()
	stats_title.text = "Статистика приключения:"
	stats_title.add_theme_font_size_override("font_size", 18)
	stats_container.add_child(stats_title)
	
	# Add separator
	var separator = HSeparator.new()
	stats_container.add_child(separator)
	
	# Add stats
	if stats.has("locations_visited"):
		var locations_label = Label.new()
		locations_label.text = "Посещено локаций: %d" % stats.locations_visited
		stats_container.add_child(locations_label)
	
	if stats.has("locations_completed"):
		var completed_label = Label.new()
		completed_label.text = "Пройдено локаций: %d" % stats.locations_completed
		stats_container.add_child(completed_label)
	
	if stats.has("knight_health") and stats.has("knight_max_health"):
		var health_label = Label.new()
		health_label.text = "Оставшееся здоровье: %d/%d" % [stats.knight_health, stats.knight_max_health]
		stats_container.add_child(health_label)
	
	if stats.has("knight_coins"):
		var coins_label = Label.new()
		coins_label.text = "Собрано монет: %d" % stats.knight_coins
		stats_container.add_child(coins_label)
	
	if stats.has("knight_has_horse"):
		var horse_label = Label.new()
		horse_label.text = "Конь: %s" % ("Сохранён" if stats.knight_has_horse else "Потерян")
		stats_container.add_child(horse_label)
	
	if stats.has("inventory_items"):
		var items_label = Label.new()
		items_label.text = "Предметов в инвентаре: %d" % stats.inventory_items
		stats_container.add_child(items_label)
	
	if stats.has("progress"):
		var progress_label = Label.new()
		progress_label.text = "Общий прогресс: %.0f%%" % stats.progress
		stats_container.add_child(progress_label)

func _on_menu_pressed() -> void:
	return_to_menu.emit()

func _on_restart_pressed() -> void:
	restart_game.emit()

func show_screen() -> void:
	show()

func hide_screen() -> void:
	hide()