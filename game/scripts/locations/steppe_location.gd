class_name SteppeLocation
extends Location

func _init() -> void:
	name = "Степь"
	description = "Бескрайние просторы степи, где дуют сильные ветра"
	icon_path = "res://assets/locations/steppe_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_nomad_traders())
	challenges.append(_create_wild_horses())
	challenges.append(_create_dust_storm())
	challenges.append(_create_abandoned_camp())
	challenges.append(_create_eagle_attack())

func _create_nomad_traders() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Кочевники-торговцы"
	challenge.description = "Встреча с караваном кочевников. Они готовы торговать, но цены высоки."
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Обменять меч на припасы"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Меч"
	action1.success_message = "Вы обменяли меч на ценные припасы."
	action1.reward_item = "Эликсир здоровья"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Купить воду (3 монеты)"
	action2.type = Challenge.ActionType.SPEND_COINS
	action2.coins_required = 3
	action2.success_message = "Вы купили фляги с водой для путешествия."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Попытаться украсть"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 2
	action3.success_message = "Вас поймали, избили, но вы сбежали с добычей."
	action3.reward_coins = 4
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Пройти мимо"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Вы решили не рисковать и продолжили путь."
	challenge.actions.append(action4)
	
	return challenge

func _create_wild_horses() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Табун диких лошадей"
	challenge.description = "Вы заметили табун диких мустангов. Может, удастся поймать одного?"
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Приманить яблоком"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Яблоко"
	action1.success_message = "Лошадь подошла за яблоком, и вы смогли её оседлать!"
	action1.reward_item = "Конь"
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Использовать лассо"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Веревка"
	action2.success_message = "Вы поймали молодого жеребца!"
	action2.reward_item = "Конь"
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Попытаться поймать голыми руками"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Лошадь лягнула вас, но вы не сдались и поймали её!"
	action3.reward_item = "Конь"
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Наблюдать издалека"
	action4.type = Challenge.ActionType.CUSTOM
	action4.success_message = "Красивое зрелище, но пора двигаться дальше."
	challenge.actions.append(action4)
	
	return challenge

func _create_dust_storm() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Пыльная буря"
	challenge.description = "Надвигается мощная пыльная буря. Нужно найти укрытие!"
	challenge.difficulty = 3
	
	var action1 = ChallengeOption.new()
	action1.text = "Укрыться под щитом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит защитил вас от летящих камней и пыли."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Быстро ускакать на коне"
	action2.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action2.requires_horse = true
	action2.success_message = "Вы обогнали бурю на своём быстром скакуне!"
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Переждать в низине"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Буря потрепала вас, но вы выжили."
	challenge.actions.append(action3)
	
	return challenge

func _create_abandoned_camp() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Заброшенный лагерь"
	challenge.description = "Вы наткнулись на недавно покинутый лагерь. Здесь могут быть полезные вещи."
	challenge.difficulty = 1
	
	var action1 = ChallengeOption.new()
	action1.text = "Тщательно обыскать"
	action1.type = Challenge.ActionType.CUSTOM
	action1.success_message = "Вы нашли монеты в старом кошельке!"
	action1.reward_coins = 3
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Проверить на ловушки факелом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Факел"
	action2.success_message = "При свете факела вы нашли спрятанный тайник!"
	action2.reward_coins = 5
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Быстро осмотреть и уйти"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы нашли немного еды и продолжили путь."
	action3.reward_item = "Хлеб"
	challenge.actions.append(action3)
	
	return challenge

func _create_eagle_attack() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Атака степного орла"
	challenge.description = "Огромный степной орёл пикирует на вас сверху!"
	challenge.difficulty = 2
	
	var action1 = ChallengeOption.new()
	action1.text = "Отбиться мечом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Меч"
	action1.success_message = "Вы отогнали орла взмахами меча."
	challenge.actions.append(action1)
	
	var action2 = ChallengeOption.new()
	action2.text = "Защититься щитом"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Щит"
	action2.success_message = "Орёл ударился о щит и улетел."
	challenge.actions.append(action2)
	
	var action3 = ChallengeOption.new()
	action3.text = "Бросить еду в сторону"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Мясо"
	action3.success_message = "Орёл отвлёкся на мясо, и вы смогли уйти."
	challenge.actions.append(action3)
	
	var action4 = ChallengeOption.new()
	action4.text = "Прикрыться руками"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Орёл поранил вас когтями, но улетел."
	challenge.actions.append(action4)
	
	return challenge