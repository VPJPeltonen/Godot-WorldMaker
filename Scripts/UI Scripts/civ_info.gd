extends VBoxContainer

var active = false

func _on_Map_map_generated():
	show()

func _on_cursor_civ_info(info):
	if typeof(info) == TYPE_DICTIONARY:
		$civ_text.text = str(info["civ name"])
	else:
		$civ_text.text = "not a civ"
