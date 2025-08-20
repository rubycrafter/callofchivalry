@tool
extends EditorScript

func _run():
	var icons = {
		"sword": Color.SILVER,
		"shield": Color.BROWN,
		"bow_arrows": Color.SADDLE_BROWN,
		"horse": Color.DARK_GOLDENROD,
		"rope": Color.BURLYWOOD,
		"torch": Color.ORANGE_RED,
		"food": Color.DARK_GREEN,
		"water_flask": Color.DODGER_BLUE,
		"warm_cloak": Color.DARK_SLATE_BLUE,
		"map": Color.BEIGE
	}
	
	for item_name in icons:
		var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
		img.fill(icons[item_name])
		img.save_png("res://game/assets/items/%s_icon.png" % item_name)
		print("Created icon: %s_icon.png" % item_name)
	
	print("All placeholder icons created!")