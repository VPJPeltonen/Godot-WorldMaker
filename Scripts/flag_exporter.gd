extends Node2D

func show_info(info):
	$warning.dialog_text = info
	$warning.show()
	
func make_map_folder():
	var dir = Directory.new()
	dir.open("user://")
	if dir.dir_exists("flags"): return true
	dir.make_dir("flags")
	return false

func get_flag_name(dir):
	var flag_name = get_parent().flag_name
	var i = 0
	while(true):
		if(dir.file_exists("user://flags/"+flag_name+".png")):
			i += 1
			flag_name += str(i)
		else:
			break
	return flag_name

func _on_save_button_pressed():
	make_map_folder()
	var dir = Directory.new()
	dir.open("user://flags")
	var flag = get_parent().get_flag()
	var flag_name = get_flag_name(dir)
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var flag_size = flag.get_node("background").texture.get_size()*10
	var flag_position = flag.position - (flag_size/2)
	var flag_rect = Rect2(flag_position,flag_size)
	image = image.get_rect(flag_rect)
	image.save_png("user://flags/"+flag_name+".png")
	show_info("Flag saved")
