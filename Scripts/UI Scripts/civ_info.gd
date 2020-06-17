extends VBoxContainer

var active = false

func _on_Map_map_generated():
	show()

func _on_cursor_civ_info(info):
	if typeof(info) == TYPE_DICTIONARY:
		show()
		$civ_text.text = str(info["civ name"])
		get_node("flag_info/flag").show()
		get_node("flag_info/flag").set_flag(info["flag"].get_flag_info())
	else:
		hide()
		$civ_text.text = "not a civ"
		get_node("flag_info/flag").hide()
