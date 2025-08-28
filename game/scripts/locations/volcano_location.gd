class_name VolcanoLocation
extends Location

func _init() -> void:
	name = "Вулкан"
	description = "Действующий вулкан с потоками лавы и ядовитыми газами"
	icon_path = "res://assets/locations/volcano_icon.png"
	min_challenges = 2
	max_challenges = 4
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_lava_river())
	challenges.append(_create_fire_elemental())
	challenges.append(_create_sulfur_clouds())
	challenges.append(_create_obsidian_bridge())
	challenges.append(_create_phoenix_encounter())

func _create_lava_river() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Река лавы"
	challenge.description = "Перед вами поток раскалённой лавы. Нужно найти способ перебраться."
	challenge.difficulty = 4
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Сделать мост из щита"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит выдержал жар, вы перебрались."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Перепрыгнуть на коне"
	action2.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action2.requires_horse = true
	action2.success_message = "Конь героически перепрыгнул через лаву!"
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Найти обходной путь"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы нашли застывший участок и обошли."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Прыгать по камням"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Вы обожглись, но перебрались."
	challenge.actions.append(action4)
	
	return challenge

func _create_fire_elemental() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Огненный элементаль"
	challenge.description = "Из лавы поднимается огненное существо, блокирующее путь."
	challenge.difficulty = 4
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Потушить водой"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Вода"
	action1.success_message = "Вода ослабила элементаля, он отступил."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Потушить вином"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Вино"
	action2.success_message = "Вино погасило часть пламени элементаля."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Атаковать мечом"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Меч"
	action3.success_message = "Меч раскалился, но вы рассеяли элементаля."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Пробежать мимо"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Вы обожглись, но пробежали."
	challenge.actions.append(action4)
	
	return challenge

func _create_sulfur_clouds() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Серные испарения"
	challenge.description = "Из трещин вырываются ядовитые серные газы."
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Дышать через мокрую ткань"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Вода"
	action1.success_message = "Мокрая ткань отфильтровала газы."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Выпить противоядие"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Эликсир здоровья"
	action2.success_message = "Эликсир защитил от отравления."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Быстро проскакать"
	action3.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action3.requires_horse = true
	action3.success_message = "Вы быстро проскакали опасную зону!"
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Задержать дыхание"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы надышались газом, но прошли."
	challenge.actions.append(action4)
	
	return challenge

func _create_obsidian_bridge() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Обсидиановый мост"
	challenge.description = "Острый как бритва мост из вулканического стекла над лавой."
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Защитить ноги щитом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит защитил от острых краёв."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Обмотать ноги веревкой"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Веревка"
	action2.success_message = "Веревка защитила ноги от порезов."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Осторожно пройти босиком"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Вы порезались, но прошли мост."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Перелететь на коне"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Конь аккуратно перешёл мост."
	challenge.actions.append(action4)
	
	return challenge

func _create_phoenix_encounter() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Огненная птица Феникс"
	challenge.description = "Легендарный феникс гнездится в кратере. Его перья ценятся на вес золота."
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Предложить золотое яблоко"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Яблоко"
	action1.success_message = "Феникс принял дар и подарил перо!"
	action1.reward_item = "Перо феникса"
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Сыграть огненную балладу"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Лютня"
	action2.success_message = "Феникс заслушался и уронил перо!"
	action2.reward_item = "Перо феникса"
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Попытаться украсть перо"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 2
	action3.success_message = "Феникс обжёг вас, но вы схватили перо!"
	action3.reward_item = "Перо феникса"
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Полюбоваться и уйти"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Вы восхитились красотой феникса."
	challenge.actions.append(action4)
	
	return challenge