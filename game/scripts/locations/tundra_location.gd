class_name TundraLocation
extends Location

func _init() -> void:
	name = "Тундра"
	description = "Холодная снежная пустошь, где выживают только сильнейшие"
	icon_path = "res://assets/locations/tundra_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_polar_bear())
	challenges.append(_create_blizzard())
	challenges.append(_create_ice_fishing())
	challenges.append(_create_frozen_traveler())
	challenges.append(_create_northern_lights())

func _create_polar_bear() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Белый медведь"
	challenge.description = "Огромный белый медведь преградил вам путь. Он голоден и агрессивен."
	challenge.difficulty = 4
	
	var action1 = ChallengeOption.new()
	action1.text = "Бросить мясо и убежать"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Мясо"
	action1.success_message = "Медведь отвлёкся на мясо, и вы смогли обойти его."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Отпугнуть факелом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Факел"
	action2.success_message = "Медведь испугался огня и ушёл."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Быстро ускакать"
	action3.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action3.requires_horse = true
	action3.success_message = "Вы умчались от медведя на коне!"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Сражаться"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Вы чудом отбились от медведя, но сильно ранены."
	action4.reward_item = "Медвежья шкура"
	challenge.actions.append(action4)
	
	return challenge

func _create_blizzard() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Снежная буря"
	challenge.description = "Внезапная метель застала вас врасплох. Видимость нулевая, холод пробирает до костей."
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Построить убежище из щита"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит защитил вас от ветра, и вы переждали бурю."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Согреться вином"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Вино"
	action2.success_message = "Вино согрело вас, и вы смогли продолжить путь."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Идти вслепую"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Вы обморозились, но выбрались из бури."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Зарыться в снег и ждать"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Снег защитил вас от ветра, буря прошла."
	challenge.actions.append(action4)
	
	return challenge

func _create_ice_fishing() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Прорубь во льду"
	challenge.description = "Вы нашли прорубь с удочкой. Можно попытаться поймать рыбу."
	challenge.difficulty = 1
	
	var action1 = ChallengeOption.new()
	action1.text = "Использовать хлеб как наживку"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Хлеб"
	action1.success_message = "Вы поймали большую рыбу!"
	action1.reward_item = "Рыба"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Попробовать без наживки"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Удивительно, но вам повезло поймать рыбу!"
	action2.reward_item = "Рыба"
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Не тратить время"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы решили не задерживаться."
	challenge.actions.append(action3)
	
	return challenge

func _create_frozen_traveler() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Замёрзший путник"
	challenge.description = "В снегу лежит замерзающий человек. Он еле дышит."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Дать эликсир здоровья"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Эликсир здоровья"
	action1.success_message = "Путник ожил и в благодарность дал вам амулет!"
	action1.reward_item = "Амулет"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Согреть вином"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Вино"
	action2.success_message = "Путник согрелся и поделился монетами."
	action2.reward_coins = 4
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Обыскать карманы"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы нашли немного монет... Не очень благородно."
	action3.reward_coins = 2
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Пройти мимо"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Вы оставили его судьбе... Жестоко."
	challenge.actions.append(action4)
	
	return challenge

func _create_northern_lights() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Северное сияние"
	challenge.description = "Небо озарилось волшебным северным сиянием. Говорят, это знак судьбы."
	challenge.difficulty = 1
	
	var action1 = ChallengeOption.new()
	action1.text = "Сыграть мелодию на лютне"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Лютня"
	action1.success_message = "Духи севера оценили вашу музыку и благословили!"
	action1.reward_coins = 3
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Помолиться"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы почувствовали прилив сил от молитвы."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Загадать желание"
	action3.type = Challenge.ActionType.SPEND_COINS
	action3.coins_required = 1
	action3.success_message = "Бросив монету в снег, вы загадали удачу в пути."
	action3.reward_coins = 3
	challenge.actions.append(action3)
	
	return challenge