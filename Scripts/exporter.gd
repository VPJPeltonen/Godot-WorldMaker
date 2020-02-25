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

func make_map_folder():
	var dir = Directory.new()
	dir.open("user://")
	if dir.dir_exists($save_box/map_name_input.text): return true
	dir.make_dir($save_box/map_name_input.text)
	return false

func save_map(map):
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.crop(1024,640)
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
		main.toggle_shadows(false)
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
			show_info("Map saved succefully")
			main.toggle_shadows(true)
			main.show_UI()
