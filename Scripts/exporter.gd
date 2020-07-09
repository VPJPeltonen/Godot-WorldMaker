extends Node2D

onready var main = get_parent().get_parent()
var save_stage
var save_path
var using_custom = false

func get_map_size():
	var map_scale = main.get_node_scale()
	var map_width = main.get_map_width()*map_scale
	var map_height = main.get_map_height()*map_scale
	return Vector2(map_width,map_height)

func make_map_folder():
	var dir = Directory.new()
	dir.open(save_path)
	dir.make_dir($save_box/map_name_input.text)

func save_map(map):
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var shot_size = get_map_size()
	if main.get_map_width() == 192:
		pass
	else:
		image.crop(shot_size.x+250,max(shot_size.y,540))
	image.save_png(save_path+$save_box/map_name_input.text+"/"+map+".png")

func save_info():
	var info_file = File.new()
	info_file.open(save_path+$save_box/map_name_input.text+"/info.txt", File.WRITE)
	var info_text = main.get_map_info()
	info_file.store_string(info_text)
	info_file.close()

func show_info(info):
	$warning.dialog_text = info
	$warning.show()
		
func _on_save_button_pressed():
	if using_custom:
		save_path = $save_box/custom_path_input.text
		save_path = save_path.replace("\\","/")
	else:
		save_path = "user://"
	if $save_box/map_name_input.text == "": show_info("You need to give the map a name")
	else:
		var dir = Directory.new()
		if dir.open(save_path) != OK:
			show_info("Something wrong with file path")
			return
		if dir.dir_exists($save_box/map_name_input.text): 
			show_info("Map already exists")
			return
		main.hide_UI()
		main.move_to_export_pos()
		main.lock_camera()
		save_stage = "start"
		$hide_timer.start()

func _on_hide_timer_timeout():
	make_map_folder()
	save_info()
	match save_stage:
		"start": #for some reason first pass still had UI. added this empty. should figure out at some point
			save_stage = "sea"
			main.color_nodes("sea")
			main.toggle_rivers(false)
			$hide_timer.start()
		"sea":
			save_map(save_stage)
			save_stage = "temperature"
			main.color_nodes("temperature")
			$hide_timer.start()
		"temperature":
			save_map(save_stage)
			save_stage = "civilizations"
			main.color_nodes("civilizations")
			$hide_timer.start()
		"civilizations":
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
			save_stage = "rivers"
			main.color_nodes("blank")
			main.toggle_rivers(true)
			$hide_timer.start()
		"rivers":
			save_map(save_stage)
			save_stage = "satellite"
			main.color_nodes("satellite")
			$hide_timer.start()
		"satellite":
			save_map(save_stage)
			show_info("Map saved succefully at C:/Users/user/AppData/Roaming/Godot/app_userdata/World Maker")
			main.show_UI()
			main.unlock_camera()

func _on_Map_map_generated():
	show()

func _on_custom_toggle_toggled(toggled):
	if toggled:
		using_custom = true
		$save_box/custom_path_input.show()
	else:
		using_custom = false
		$save_box/custom_path_input.hide()
