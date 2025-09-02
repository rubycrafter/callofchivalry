class_name SwampLocation
extends Location

func _init() -> void:
	name = "Болото"
	description = "Зловонные топи, полные опасных тварей и ядовитых испарений"
	icon_path = "res://assets/locations/swamp_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_quicksand())
	challenges.append(_create_swamp_witch())
	challenges.append(_create_giant_leech())
	challenges.append(_create_will_o_wisp())
	challenges.append(_create_toxic_fog())

func _create_quicksand() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Трясина"
	challenge.description = "Вы начинаете проваливаться в зыбучие пески! Нужно срочно выбираться!"
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Зацепиться веревкой за дерево"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Веревка"
	action1.success_message = "Вы вытянули себя с помощью веревки."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Использовать щит как опору"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Щит"
	action2.success_message = "Щит помог распределить вес, и вы выбрались."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Позвать коня на помощь"
	action3.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action3.requires_horse = true
	action3.success_message = "Верный конь вытянул вас из трясины!"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Выбираться самому"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Вы выбрались, но сильно измучились."
	challenge.actions.append(action4)
	
	return challenge

func _create_swamp_witch() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Болотная ведьма"
	challenge.description = "Старая ведьма предлагает вам сделку: она поможет, но за определённую цену."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Заплатить за зелье (4 монеты)"
	action1.type = Challenge.ActionType.SPEND_COINS
	action1.coins_required = 4
	action1.success_message = "Ведьма дала вам целебное зелье."
	action1.reward_item = "Эликсир здоровья"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Обменять амулет на проход"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Амулет"
	action2.success_message = "Ведьма взяла амулет и показала безопасную тропу."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Развлечь её музыкой"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Лютня"
	action3.success_message = "Ведьме понравилась музыка, она дала вам монет."
	action3.reward_coins = 3
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Отказаться и уйти"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Ведьма прокляла вас на прощание."
	challenge.actions.append(action4)
	
	return challenge

func _create_giant_leech() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Гигантская пиявка"
	challenge.description = "Из воды выползла огромная пиявка и пытается присосаться!"
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Отрезать мечом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Меч"
	action1.success_message = "Вы разрубили пиявку пополам."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Прижечь факелом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Факел"
	action2.success_message = "Пиявка отвалилась от огня."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Посыпать солью"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Соль"
	action3.success_message = "Соль заставила пиявку съёжиться и отпасть."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Оторвать руками"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы оторвали пиявку, но она успела высосать кровь."
	challenge.actions.append(action4)
	
	return challenge

func _create_will_o_wisp() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Блуждающие огни"
	challenge.description = "Таинственные огоньки манят вас в глубь болота. Это может быть ловушка."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Следовать с картой"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Карта"
	action1.success_message = "Карта помогла не сбиться с пути, огни привели к кладу!"
	action1.reward_coins = 5
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Игнорировать огни"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы мудро проигнорировали огни и продолжили путь."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Следовать за огнями"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Огни завели вас в топь, но вы нашли монеты утопленника."
	action3.reward_coins = 2
	challenge.actions.append(action3)
	
	return challenge

func _create_toxic_fog() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Ядовитый туман"
	challenge.description = "Поднимается зелёный туман с ядовитыми испарениями. Дышать становится трудно."
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Выпить противоядие"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Эликсир здоровья"
	action1.success_message = "Эликсир нейтрализовал яд, вы прошли невредимым."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Дышать через ткань, смоченную вином"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Вино"
	action2.success_message = "Винные пары помогли фильтровать воздух."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Быстро проскакать"
	action3.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action3.requires_horse = true
	action3.success_message = "Вы быстро проскакали через туман на коне!"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Задержать дыхание и бежать"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы пробежали, но надышались ядом."
	challenge.actions.append(action4)
	
	return challenge