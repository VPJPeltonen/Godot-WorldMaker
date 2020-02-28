extends Node2D

onready var main = get_parent().get_parent()
var save_stage

func get_map_size():
	var map_scale = main.get_node_scale()
	var map_width = main.get_map_width()*map_scale
	var map_height = main.get_map_height()*map_scale
	return Vector2(map_width,map_height)

func make_map_folder():
	var dir = Directory.new()
	dir.open("user://")
	if dir.dir_exists($save_box/map_name_input.text): return true
	dir.make_dir($save_box/map_name_input.text)
	return false

func save_map(map):
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var shot_size = get_map_size()
	image.crop(shot_size.x+250,max(shot_size.y,540))
	image.save_png("user://"+$save_box/map_name_input.text+"/"+map+".png")

func show_info(info):
	$warning.dialog_text = info
	$warning.show()
		
func _on_save_button_pressed():
	if $save_box/map_name_input.text == "": show_info("You need to give the map a name")
	elif make_map_folder(): show_info("Map already exists")
	else:
		main.hide_UI()
		main.move_to_export_pos()
		#main.toggle_shadows(false)
		main.lock_camera()
		save_stage = "start"
		$hide_timer.start()

func _on_hide_timer_timeout():
	make_map_folder()
	match save_stage:
		"start": #for some reason first pass still had UI. added this empty. should figure out at some point
			save_stage = "sea"
			main.color_nodes("sea")
			$hide_timer.start()
		"sea":
			save_map(save_stage)
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
			show_info("Map saved succefully at C:/Users/user/AppData/Roaming/Godot/app_userdata/World Maker")
			#main.toggle_shadows(true)
			main.show_UI()
			main.unlock_camera()

func _on_Map_map_generated():
	show()
