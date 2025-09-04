class_name DesertLocation
extends Location

func _init() -> void:
	name = "Пустыня"
	description = "Раскалённые пески, где днём жарко, а ночью холодно"
	icon_path = "res://assets/locations/desert_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_oasis_mirage())
	challenges.append(_create_sand_storm())
	challenges.append(_create_scorpion_nest())
	challenges.append(_create_desert_bandits())
	challenges.append(_create_ancient_sphinx())

func _create_oasis_mirage() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Мираж оазиса"
	challenge.description = "Впереди виднеется оазис с водой, но это может быть мираж."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Проверить с помощью карты"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Карта"
	action1.success_message = "Карта показала настоящий оазис! Вы пополнили запасы воды."
	action1.reward_item = "Вода"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Идти к оазису"
	action2.type = Challenge.ActionType.TAKE_DAMAGE
	action2.damage_taken = 1
	action2.success_message = "Это был мираж, вы потеряли силы в поисках воды."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Игнорировать и идти дальше"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы не поддались иллюзии и продолжили путь."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Послать коня проверить"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Конь вернулся с мокрой мордой - оазис настоящий!"
	action4.reward_item = "Вода"
	challenge.actions.append(action4)
	
	return challenge

func _create_sand_storm() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Песчаная буря"
	challenge.description = "Поднимается мощная песчаная буря. Песок забивается везде!"
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Укрыться за щитом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит защитил от песка, вы переждали бурю."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Зарыться в песок"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы зарылись в песок и переждали бурю."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Обогнать бурю на коне"
	action3.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action3.requires_horse = true
	action3.success_message = "Вы ускакали от бури на быстром коне!"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Идти сквозь бурю"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Буря сильно потрепала вас, но вы прошли."
	challenge.actions.append(action4)
	
	return challenge

func _create_scorpion_nest() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Гнездо скорпионов"
	challenge.description = "Вы потревожили гнездо пустынных скорпионов. Они окружают вас!"
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Отпугнуть факелом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Факел"
	action1.success_message = "Скорпионы боятся огня и разбежались."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Давить сапогами"
	action2.type = Challenge.ActionType.TAKE_DAMAGE
	action2.damage_taken = 1
	action2.success_message = "Вы раздавили скорпионов, но один успел ужалить."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Использовать противоядие превентивно"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Эликсир здоровья"
	action3.success_message = "Противоядие защитило вас, вы спокойно прошли."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Перепрыгнуть на коне"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Конь ловко перепрыгнул через скорпионов."
	challenge.actions.append(action4)
	
	return challenge

func _create_desert_bandits() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Пустынные разбойники"
	challenge.description = "Банда разбойников на верблюдах окружила вас и требует выкуп."
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Откупиться золотом (6 монет)"
	action1.type = Challenge.ActionType.SPEND_COINS
	action1.coins_required = 6
	action1.success_message = "Разбойники взяли золото и уехали."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Предложить обмен на меч"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Меч"
	action2.success_message = "Разбойники взяли меч и дали пройти."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Драться"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 2
	action3.success_message = "Вы отбились, но получили ранения."
	action3.reward_coins = 3
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Блефовать о подкреплении"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Разбойники поверили в блеф и отступили."
	challenge.actions.append(action4)
	
	return challenge

func _create_ancient_sphinx() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Древний сфинкс"
	challenge.description = "Каменный сфинкс преграждает путь и задаёт загадку."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Ответить на загадку с помощью книги"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Книга"
	action1.success_message = "Книга помогла разгадать загадку! Сфинкс дал награду."
	action1.reward_coins = 5
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Попытаться угадать"
	action2.type = Challenge.ActionType.SPEND_COINS
	action2.coins_required = 2
	action2.success_message = "После нескольких попыток вы угадали!"
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Обойти сфинкса"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Вы обошли, но сфинкс проклял вас."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Сыграть мелодию"
	action4.type = Challenge.ActionType.USE_ITEM
	action4.item_required = "Лютня"
	action4.success_message = "Сфинкс оценил музыку и пропустил вас."
	challenge.actions.append(action4)
	
	return challenge