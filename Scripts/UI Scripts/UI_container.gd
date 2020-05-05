extends VBoxContainer

export(PackedScene) var scene_file

func _on_Map_map_generated():
	show()

func _on_done_adjusting():
	get_node("adjustments").hide()
	get_node("done_list").hide()
	get_node("civ_settings").show()
