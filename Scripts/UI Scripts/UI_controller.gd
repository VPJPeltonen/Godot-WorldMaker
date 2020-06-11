extends CanvasLayer

func _on_makeflag_button_pressed():
	get_node("OpeningMenu").hide()
	get_node("info_label").hide()
	get_node("FlagGenerator").show()


func _on_FlagGenerator_back():
	get_node("OpeningMenu").show()
	get_node("info_label").show()
	get_node("FlagGenerator").hide()
