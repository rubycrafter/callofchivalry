class_name MountainLocation
extends Location

func _init() -> void:
	name = "Гора"
	description = "Высокие скалистые вершины, где воздух разрежён и путь опасен"
	icon_path = "res://assets/locations/mountain_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_rock_slide())
	challenges.append(_create_mountain_pass())
	challenges.append(_create_hermit_encounter())
	challenges.append(_create_griffin_nest())
	challenges.append(_create_thin_air())

func _create_rock_slide() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Камнепад"
	challenge.description = "Сверху падают огромные валуны! Нужно срочно найти укрытие!"
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Защититься щитом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит защитил от камней."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Спрятаться в расщелине"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы переждали камнепад в безопасном месте."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Проскакать на коне"
	action3.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action3.requires_horse = true
	action3.success_message = "Вы быстро проскакали опасную зону!"
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Бежать зигзагом"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Камень задел вас, но вы выжили."
	challenge.actions.append(action4)
	
	return challenge

func _create_mountain_pass() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Узкий перевал"
	challenge.description = "Очень узкая тропа вдоль обрыва. Один неверный шаг - падение в пропасть."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Страховаться веревкой"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Веревка"
	action1.success_message = "Веревка помогла безопасно пройти."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Идти медленно и осторожно"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы осторожно прошли по тропе."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Проверять путь топором"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Топор"
	action3.success_message = "Топор помог расширить тропу в узких местах."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Идти быстро, не глядя вниз"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы оступились и поранились, но прошли."
	challenge.actions.append(action4)
	
	return challenge

func _create_hermit_encounter() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Горный отшельник"
	challenge.description = "Старый отшельник живёт в пещере. Он знает тайны гор."
	challenge.difficulty = 1
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Поделиться едой"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Хлеб"
	action1.success_message = "Отшельник поделился древней картой!"
	action1.reward_item = "Карта"
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Угостить вином"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Вино"
	action2.success_message = "Отшельник рассказал о спрятанном кладе!"
	action2.reward_coins = 4
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Сыграть музыку"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Лютня"
	action3.success_message = "Отшельник благословил ваш путь."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Пройти мимо"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Вы не стали беспокоить отшельника."
	challenge.actions.append(action4)
	
	return challenge

func _create_griffin_nest() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Гнездо грифона"
	challenge.description = "Огромный грифон защищает своё гнездо на вершине скалы."
	challenge.difficulty = 4
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Отвлечь мясом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Мясо"
	action1.success_message = "Грифон отвлёкся, вы забрали золотое яйцо!"
	action1.reward_coins = 8
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Сражаться мечом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Меч"
	action2.success_message = "Вы отогнали грифона мечом."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Обойти стороной"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы мудро обошли грифона."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Попытаться проскочить"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Грифон ранил вас когтями, но вы убежали."
	challenge.actions.append(action4)
	
	return challenge

func _create_thin_air() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Разреженный воздух"
	challenge.description = "На большой высоте трудно дышать. Голова кружится, силы покидают."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Выпить тонизирующий эликсир"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Эликсир здоровья"
	action1.success_message = "Эликсир придал сил для подъёма."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Подкрепиться вином"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Вино"
	action2.success_message = "Вино помогло согреться и взбодриться."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Отдохнуть и акклиматизироваться"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Отдых помог привыкнуть к высоте."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Преодолеть силой воли"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы заставили себя идти, но переутомились."
	challenge.actions.append(action4)
	
	return challenge