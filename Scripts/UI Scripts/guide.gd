extends ColorRect

export(Resource) var node
export(Resource) var label
export(Resource) var flag

onready var main = get_parent().get_parent()

func view(mode):	
	move_position()
	clear()
	if mode == "civilizations":
		show_civ_info()
	else:
		show_info(mode)

func show_civ_info():
	var y_pos = 20
	var civs = get_parent().get_civs()
	rect_size.y = (civs.size()-1)*20+40
	for civ in civs:
		var new_node = node.instance()
		add_child(new_node)
		new_node.position = Vector2(20,0+y_pos)
		var civ_color = Color(json_reader.get_color("continent",str(civ.civ_color)))
		new_node.set_self_modulate(civ_color)
		
		var new_flag = flag.instance()
		add_child(new_flag)
		new_flag.position = Vector2(50,0+y_pos)
		new_flag.set_flag(civ.get_node("flag").get_flag_info())
		new_flag.show()
		
		var new_label = label.instance()
		add_child(new_label)
		new_label.rect_position = Vector2(80,0+y_pos-6)
		new_label.text = civ.civ_name
		y_pos += 20
		
func show_info(mode):
	var options = json_reader.get_colors(mode)
	var y_pos = 20
	rect_size.y = (options.size()-1)*20+40
	for type in options:
		var new_node = node.instance()
		add_child(new_node)
		new_node.position = Vector2(20,0+y_pos)
		new_node.set_self_modulate(Color(options[type]))
		
		var new_label = label.instance()
		add_child(new_label)
		new_label.rect_position  = Vector2(40,0+y_pos-6)
		new_label.text = type
		y_pos += 20
			
func move_position():
	var map_size = main.get_map_width()*main.get_node_scale()
	rect_position.x = map_size

func clear():
	for n in get_children():
		remove_child(n)
		n.queue_free()
