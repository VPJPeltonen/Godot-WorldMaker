extends CanvasLayer

var seed_toggle = false

func get_map_seed():
	if seed_toggle:
		return $generation_UI/seed_box/seed_text.text
	else:
		return null

func _on_makeflag_button_pressed():
	get_node("OpeningMenu").hide()
	get_node("info_label").hide()
	get_node("FlagGenerator").show()

func _on_FlagGenerator_back():
	get_node("OpeningMenu").show()
	get_node("info_label").show()
	get_node("FlagGenerator").hide()

func _on_makemap_button_pressed():
	get_node("OpeningMenu").hide()
	get_node("generation_UI").show()

func _on_generation_back_button_pressed():
	get_node("OpeningMenu").show()
	get_node("generation_UI").hide()

func _on_seed_toggle_toggled(toggled_on):
	seed_toggle = toggled_on
	if toggled_on:	
		get_node("generation_UI/seed_box/seed_text").show()
	else:
		get_node("generation_UI/seed_box/seed_text").hide()

func _on_Map_map_generated():
	$UI_container/MapSeed/seed_label.text = randomizer.seed_string

func _on_Camera2D_zoom_amount(amount):
	var percentage = round((1/amount.x) * 100)
	$zoom_text.text = str(percentage) + "%"
 #0.5

func _on_Camera2D_camera_position(c_position):
	$pos_text.text = str(c_position)
