extends Node2D

func screenshot():
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("sad")
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("user://sad/screenshot.png")

func make_map_folder():
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir($save_box/map_name_input.text)
	
func save_maps():
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("user://"+$save_box/map_name_input.text+"/screenshot.png")

func _on_screenshot_button_pressed():
	screenshot()

func _on_save_button_pressed():
	var old_size = get_viewport().size
	var map_size = get_parent().get_map_size()
	get_viewport().size = map_size
	if $save_box/map_name_input.text == "":
		$warning.dialog_text = "You need to give the map a name"
		$warning.show()
	else:
		make_map_folder()
		save_maps()
		$warning.dialog_text = "Map saved succefully"
		$warning.show()
	get_viewport().size = old_size
