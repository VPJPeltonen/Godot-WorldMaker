extends Node2D

var main
var save_stage

func _ready():
	main = get_parent().get_parent()

func get_map_size():
	var map_scale = get_parent().get_node_scale()
	var map_width = get_parent().get_map_width()*map_scale
	var map_height = get_parent().get_map_height()*map_scale
	return Vector2(map_width,map_height)
	
#func screenshot():
#	var dir = Directory.new()
#	dir.open("user://")
#	dir.make_dir("sad")
#	var image = get_viewport().get_texture().get_data()
#	image.flip_y()
#	image.save_png("user://sad/screenshot.png")

func make_map_folder():
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir($save_box/map_name_input.text)
	
#func save_maps():
#	save_map("elevation")

func save_map(map):
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.crop(1024,640)
	image.save_png("user://"+$save_box/map_name_input.text+"/"+map+".png")
	
#func _on_screenshot_button_pressed():
#	screenshot()

func _on_save_button_pressed():
	main.hide_UI()
	main.move_to_export_pos()
	main.toggle_shadows(false)
	main.color_nodes("sea")
	save_stage = "start"
	$hide_timer.start()

func _on_hide_timer_timeout():
	if $save_box/map_name_input.text == "":
		$warning.dialog_text = "You need to give the map a name"
		$warning.show()
	else:
		match save_stage:
			"start":
				save_stage = "sea"
				main.color_nodes("sea")
				$hide_timer.start()				
			"sea":
				make_map_folder()
				save_map("sea")
				save_stage = "temperature"
				main.color_nodes("temperature")
				$hide_timer.start()
			"temperature":
				save_map(save_stage)
				save_stage = "climate"
				main.color_nodes("climate")
				$hide_timer.start()
			"climate":
				save_map(save_stage)
				save_stage = "rainfall"
				main.color_nodes("rainfall")
				$hide_timer.start()
			"rainfall":
				save_map(save_stage)
				save_stage = "satellite"
				main.color_nodes("satellite")
				$hide_timer.start()
			"satellite":
				save_map(save_stage)
				$warning.dialog_text = "Map saved succefully"
				$warning.show()
				main.toggle_shadows(true)
				main.show_UI()
