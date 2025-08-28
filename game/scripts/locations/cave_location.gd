class_name CaveLocation
extends Location

func _init() -> void:
	name = "Пещера"
	description = "Тёмные подземные лабиринты, полные опасностей и древних тайн"
	icon_path = "res://assets/locations/cave_icon.png"
	min_challenges = 2
	max_challenges = 4
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_darkness())
	challenges.append(_create_cave_troll())
	challenges.append(_create_underground_river())
	challenges.append(_create_ancient_tomb())
	challenges.append(_create_crystal_cavern())

func _create_darkness() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Кромешная тьма"
	challenge.description = "В пещере абсолютная темнота. Вы не видите даже собственных рук."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Зажечь факел"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Факел"
	action1.success_message = "Факел осветил путь вперёд."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Идти на ощупь по стене"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы медленно продвигаетесь во тьме."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Идти наугад"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Вы несколько раз упали, но нашли выход."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Следовать за звуками воды"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Звук воды вывел вас к подземной реке."
	challenge.actions.append(action4)
	
	return challenge

func _create_cave_troll() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Пещерный тролль"
	challenge.description = "Огромный тролль блокирует единственный проход. Он требует плату."
	challenge.difficulty = 4
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Заплатить золотом (7 монет)"
	action1.type = Challenge.ActionType.SPEND_COINS
	action1.coins_required = 7
	action1.success_message = "Тролль взял золото и пропустил вас."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Сражаться мечом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Меч"
	action2.success_message = "Вы победили тролля в бою!"
	action2.reward_coins = 5
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Отвлечь едой"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Мясо"
	action3.success_message = "Тролль отвлёкся на еду, вы проскользнули."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Драться кулаками"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Тролль избил вас, но пропустил из уважения."
	challenge.actions.append(action4)
	
	return challenge

func _create_underground_river() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Подземная река"
	challenge.description = "Быстрая подземная река преграждает путь. Вода ледяная."
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Построить плот из щита"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит послужил плотом для переправы."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Перейти вброд с веревкой"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Веревка"
	action2.success_message = "Веревка помогла не снести течением."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Переплыть на коне"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Конь переплыл реку с вами на спине."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Переплыть самому"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы переплыли, но сильно замёрзли."
	challenge.actions.append(action4)
	
	return challenge

func _create_ancient_tomb() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Древняя гробница"
	challenge.description = "Вы нашли древнее захоронение. Саркофаг выглядит нетронутым."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Открыть с помощью топора"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Топор"
	action1.success_message = "В гробнице лежали древние сокровища!"
	action1.reward_coins = 8
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Исследовать с факелом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Факел"
	action2.success_message = "При свете факела вы нашли тайник!"
	action2.reward_item = "Древний артефакт"
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Помолиться и уйти"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы почтили память усопших."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Разграбить гробницу"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы взяли золото, но сработала ловушка!"
	action4.reward_coins = 5
	challenge.actions.append(action4)
	
	return challenge

func _create_crystal_cavern() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Хрустальная пещера"
	challenge.description = "Пещера полна светящихся кристаллов. Они излучают странную энергию."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Собрать кристаллы топором"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Топор"
	action1.success_message = "Вы добыли ценные магические кристаллы!"
	action1.reward_item = "Магический кристалл"
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Медитировать среди кристаллов"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Кристаллы восстановили ваши силы."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Играть музыку кристаллам"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Лютня"
	action3.success_message = "Кристаллы зазвучали в ответ и подарили энергию!"
	action3.reward_coins = 4
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Разбить кристаллы"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Осколки поранили вас, но вы нашли золото внутри."
	action4.reward_coins = 3
	challenge.actions.append(action4)
	
	return challenge