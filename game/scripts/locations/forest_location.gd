class_name ForestLocation
extends Location

func _init() -> void:
	name = "Лес"
	description = "Тёмный лес, полный опасностей и тайн"
	icon_path = "res://assets/locations/forest_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_bandit_encounter())
	challenges.append(_create_wolf_pack())
	challenges.append(_create_lost_merchant())
	challenges.append(_create_fallen_tree())
	challenges.append(_create_fairy_ring())

func _create_bandit_encounter() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Встреча с бандитами"
	challenge.description = "Группа разбойников преградила вам путь и требует плату за проход."
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Атаковать мечом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Меч"
	action1.success_message = "Вы разогнали бандитов своим мечом! За их головы вам дали награду."
	action1.reward_coins = 3
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Ускакать на коне"
	action2.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action2.requires_horse = true
	action2.success_message = "Вы быстро ускакали от бандитов!"
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Откупиться (5 монет)"
	action3.type = Challenge.ActionType.SPEND_COINS
	action3.coins_required = 5
	action3.success_message = "Бандиты взяли деньги и пропустили вас."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Вступить в драку"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы пробились через бандитов, но получили ранение."
	challenge.actions.append(action4)
	
	return challenge

func _create_wolf_pack() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Волчья стая"
	challenge.description = "Голодные волки окружили вас, их глаза светятся в темноте."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Отпугнуть факелом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Факел"
	action1.success_message = "Волки испугались огня и убежали."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Бросить мясо"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Мясо"
	action2.success_message = "Волки отвлеклись на мясо, и вы смогли уйти."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Забраться на дерево"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Веревка"
	action3.success_message = "Вы забрались на дерево и переждали, пока волки ушли."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Пробиваться силой"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 2
	action4.success_message = "Вы пробились через стаю, но сильно пострадали."
	challenge.actions.append(action4)
	
	return challenge

func _create_lost_merchant() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Потерявшийся торговец"
	challenge.description = "Вы встретили торговца, который заблудился в лесу и просит помощи."
	challenge.difficulty = 1
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Показать карту"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Карта"
	action1.success_message = "Торговец благодарит вас и дарит редкий эликсир!"
	action1.reward_item = "Эликсир здоровья"
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Проводить за плату"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы провели торговца, и он заплатил вам."
	action2.reward_coins = 2
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Ограбить торговца"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы ограбили беднягу... Не очень рыцарский поступок."
	action3.reward_coins = 5
	challenge.actions.append(action3)
	
	return challenge

func _create_fallen_tree() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Поваленное дерево"
	challenge.description = "Огромное дерево преграждает тропу. Нужно как-то пройти дальше."
	challenge.difficulty = 1
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Разрубить топором"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Топор"
	action1.success_message = "Вы расчистили путь топором."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Перепрыгнуть на коне"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Конь легко перепрыгнул через препятствие."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Обойти через чащу"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 1
	action3.success_message = "Вы пробрались через колючие кусты."
	challenge.actions.append(action3)
	
	return challenge

func _create_fairy_ring() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Волшебное кольцо грибов"
	challenge.description = "Вы наткнулись на кольцо из светящихся грибов. Легенды гласят, что это место силы."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Сыграть на лютне"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Лютня"
	action1.success_message = "Феи оценили вашу музыку и благословили вас!"
	action1.reward_coins = 3
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Оставить подношение"
	action2.type = Challenge.ActionType.SPEND_COINS
	action2.coins_required = 2
	action2.success_message = "Ваше подношение принято, взамен вы получили волшебный амулет."
	action2.reward_item = "Амулет"
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Пройти мимо"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы осторожно обошли волшебное место."
	challenge.actions.append(action3)
	
	return challenge