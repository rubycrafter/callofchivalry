class_name GlacierLocation
extends Location

func _init() -> void:
	name = "Ледник"
	description = "Вечные льды и скользкие склоны, где легко сорваться в пропасть"
	icon_path = "res://assets/locations/glacier_icon.png"
	min_challenges = 1
	max_challenges = 3
	
	_create_challenges()

func _create_challenges() -> void:
	challenges.clear()
	
	challenges.append(_create_ice_bridge())
	challenges.append(_create_avalanche())
	challenges.append(_create_ice_cave())
	challenges.append(_create_frozen_lake())
	challenges.append(_create_yeti_encounter())

func _create_ice_bridge() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Ледяной мост"
	challenge.description = "Хрупкий ледяной мост над пропастью. Один неверный шаг - и конец."
	challenge.difficulty = 3
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Проверить прочность веревкой"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Веревка"
	action1.success_message = "Веревка помогла безопасно перейти мост."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Ползти, распределив вес"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы осторожно переползли по мосту."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Быстро перебежать"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 2
	action3.success_message = "Мост треснул, вы упали, но выжили."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Перепрыгнуть на коне"
	action4.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action4.requires_horse = true
	action4.success_message = "Конь одним прыжком преодолел пропасть!"
	challenge.actions.append(action4)
	
	return challenge

func _create_avalanche() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Лавина"
	challenge.description = "Громкий звук спровоцировал лавину! Снежная стена несётся на вас!"
	challenge.difficulty = 4
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Спрятаться за щитом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Щит"
	action1.success_message = "Щит защитил от снега, вы откопались."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Ускакать в сторону"
	action2.type = Challenge.ActionType.ESCAPE_ON_HORSE
	action2.requires_horse = true
	action2.success_message = "Вы ускакали от лавины на коне!"
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Попытаться убежать"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 2
	action3.success_message = "Лавина накрыла вас, но вы выкопались."
	challenge.actions.append(action3)
	
	return challenge

func _create_ice_cave() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Ледяная пещера"
	challenge.description = "Вы нашли пещеру во льду. Внутри темно и холодно, но может быть укрытие."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Исследовать с факелом"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Факел"
	action1.success_message = "При свете факела вы нашли древний клад!"
	action1.reward_coins = 6
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Заночевать в пещере"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы переждали холодную ночь в укрытии."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Идти дальше"
	action3.type = Challenge.ActionType.CUSTOM
	action3.success_message = "Вы решили не задерживаться."
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Исследовать в темноте"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Вы упали в яму, но нашли монеты."
	action4.reward_coins = 2
	challenge.actions.append(action4)
	
	return challenge

func _create_frozen_lake() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Замёрзшее озеро"
	challenge.description = "Перед вами замёрзшее озеро. Лёд выглядит тонким местами."
	challenge.difficulty = 2
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Проверить лёд топором"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Топор"
	action1.success_message = "Топор помог найти прочный путь."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Обойти по берегу"
	action2.type = Challenge.ActionType.CUSTOM
	action2.success_message = "Вы безопасно обошли озеро."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Скользить по льду на щите"
	action3.type = Challenge.ActionType.USE_ITEM
	action3.item_required = "Щит"
	action3.success_message = "Вы быстро проскользили на щите!"
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Идти напрямик"
	action4.type = Challenge.ActionType.TAKE_DAMAGE
	action4.damage_taken = 1
	action4.success_message = "Лёд треснул, вы промокли и замёрзли."
	challenge.actions.append(action4)
	
	return challenge

func _create_yeti_encounter() -> Challenge:
	var challenge = Challenge.new()
	challenge.title = "Снежный человек"
	challenge.description = "Легендарный йети преградил путь. Он огромен и выглядит голодным."
	challenge.difficulty = 4
	
	var action1 = Challenge.ChallengeAction.new()
	action1.text = "Бросить мясо"
	action1.type = Challenge.ActionType.USE_ITEM
	action1.item_required = "Мясо"
	action1.success_message = "Йети взял мясо и ушёл довольным."
	challenge.actions.append(action1)
	
	var action2 = Challenge.ChallengeAction.new()
	action2.text = "Отпугнуть огнём"
	action2.type = Challenge.ActionType.USE_ITEM
	action2.item_required = "Факел"
	action2.success_message = "Йети испугался огня и убежал."
	challenge.actions.append(action2)
	
	var action3 = Challenge.ChallengeAction.new()
	action3.text = "Сражаться"
	action3.type = Challenge.ActionType.TAKE_DAMAGE
	action3.damage_taken = 3
	action3.success_message = "Вы едва победили йети в жестокой схватке."
	action3.reward_item = "Шкура йети"
	challenge.actions.append(action3)
	
	var action4 = Challenge.ChallengeAction.new()
	action4.text = "Сыграть успокаивающую мелодию"
	action4.type = Challenge.ActionType.USE_ITEM
	action4.item_required = "Лютня"
	action4.success_message = "Музыка усыпила йети, вы прошли мимо."
	challenge.actions.append(action4)
	
	return challenge