class_name DragonLairLocation
extends Location

func _init() -> void:
	name = "Логово дракона"
	description = "Финальное испытание - битва с древним драконом за спасение королевства"
	icon_path = "res://assets/locations/dragon_lair_icon.png"
	min_challenges = 3
	max_challenges = 5
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_dragon_guards())
	challenges.append(_create_treasure_room())
	challenges.append(_create_dragon_riddle())
	challenges.append(_create_princess_rescue())
	challenges.append(_create_final_battle())

func _create_dragon_guards() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Драконьи стражи"
	challenge.description = "Два меньших дракона охраняют вход в главное логово."
	challenge.difficulty = 4
	
	var action1 = ChallengeOption.new()
	action1.text = "Сражаться мечом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Меч"
	action1.success_message = "Вы героически победили стражей!"
	action1.reward_coins = 5
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Усыпить музыкой"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Лютня"
	action2.success_message = "Драконы заснули под вашу колыбельную."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Отвлечь золотом"
	action3.type = Challenge.ActionType.SPEND_COINS
	action3.coins_required = 5
	action3.success_message = "Стражи отвлеклись на золото."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Прорваться силой"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Вы прорвались, но сильно ранены."
	challenge.actions.append(action4)
	
	return challenge

func _create_treasure_room() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Сокровищница дракона"
	challenge.description = "Горы золота и артефактов. Но взять что-то - значит разбудить дракона."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Взять только необходимое"
	action1.type = Challenge.ActionType.CUSTOM
	action1.success_message = "Вы взяли зелье для битвы."
	action1.reward_item = "Эликсир силы дракона"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Набить карманы золотом"
	action2.type = Challenge.ActionType.TAKE_DAMAGE
	action2.damage_taken = 1
	action2.success_message = "Дракон почувствовал кражу и опалил вас!"
	action2.reward_coins = 10
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Не брать ничего"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы прошли мимо сокровищ."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Искать магическое оружие"
	action4.type = Challenge.ActionType.USE_ITEM
	action4.item_required = "Карта"
	action4.success_message = "Карта привела к легендарному мечу!"
	action4.reward_item = "Драконобойный меч"
	challenge.actions.append(action4)
	
	return challenge

func _create_dragon_riddle() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Загадка древнего дракона"
	challenge.description = "Дракон предлагает разгадать загадку вместо битвы."
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Ответить с помощью книги мудрости"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Книга"
	action1.success_message = "Дракон впечатлён вашей мудростью!"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Попросить подсказку за золото"
	action2.type = Challenge.ActionType.SPEND_COINS
	action2.coins_required = 3
	action2.success_message = "Дракон дал подсказку, вы разгадали!"
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Отказаться и сражаться"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 2
	action3.success_message = "Дракон разозлился и атаковал!"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Ответить загадкой на загадку"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Дракон оценил вашу находчивость!"
	challenge.actions.append(action4)
	
	return challenge

func _create_princess_rescue() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Спасение принцессы"
	challenge.description = "Принцесса заперта в клетке над лавой. Дракон предлагает выбор."
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Разрубить клетку мечом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Меч"
	action1.success_message = "Вы освободили принцессу!"
	action1.reward_item = "Благословение принцессы"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Обменять на все сокровища"
	action2.type = Challenge.ActionType.SPEND_COINS
	action2.coins_required = 10
	action2.success_message = "Дракон принял выкуп и освободил принцессу."
	action2.reward_item = "Благословение принцессы"
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Использовать веревку для спасения"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Веревка"
	action3.success_message = "Вы вытащили принцессу веревкой!"
	action3.reward_item = "Благословение принцессы"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Сначала убить дракона"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Вы решили сначала разобраться с драконом."
	challenge.actions.append(action4)
	
	return challenge

func _create_final_battle() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Битва с древним драконом"
	challenge.description = "Финальная битва! Дракон в ярости и готов испепелить вас!"
	challenge.difficulty = 5
	
	var action1 = ChallengeOption.new()
	action1.text = "Атаковать драконобойным мечом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Драконобойный меч"
	action1.success_message = "Легендарный меч пронзил сердце дракона! ПОБЕДА!"
	action1.reward_coins = 100
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Использовать перо феникса"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Перо феникса"
	action2.success_message = "Магия феникса ослабила дракона, и вы победили!"
	action2.reward_coins = 50
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Сражаться обычным оружием"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Меч"
	action3.success_message = "Невероятно! Вы победили дракона обычным мечом!"
	action3.reward_coins = 30
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Сражаться голыми руками"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 3
	action4.success_message = "Легенда! Вы победили дракона кулаками!"
	action4.reward_coins = 200
	challenge.actions.append(action4)
	
	var action5 = ChallengeOption.new()
	action5.text = "Договориться с драконом"
	action5.type = Challenge.ActionType.USE_ITEM
	action5.item_required = "Лютня"
	action5.success_message = "Ваша музыка тронула сердце дракона. Мир заключён!"
	action5.reward_coins = 75
	challenge.actions.append(action5)
	
	return challenge