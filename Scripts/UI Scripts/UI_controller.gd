extends CanvasLayer

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
	get_node("generate_button").show()
	get_node("generation_back_button").show()

func _on_generation_back_button_pressed():
	get_node("OpeningMenu").show()
	get_node("generation_UI").hide()
	get_node("generate_button").hide()
	get_node("generation_back_button").hide()


func _on_generate_button_pressed():
	get_node("generation_back_button").hide()
