extends Sprite

signal node_info(elevation)

var map_generated = false
var map_width
var map_height

func _process(delta):
	if !map_generated:
		hide()
		return
	position.x = get_viewport().get_mouse_position().x - fmod(get_viewport().get_mouse_position().x,8) 
	position.y = get_viewport().get_mouse_position().y - fmod(get_viewport().get_mouse_position().y,8) + 4
	var X = (position.x-100)/8
	var Y = (position.y-4)/8
	if position.x > 96 and position.x < map_width and position.y < map_height:
		show()
		var info = get_parent().get_node_info(X,Y)
		emit_signal("node_info", info, X, Y)
	else:
		hide()
		
func _on_Map_map_generated():
	map_generated = true
	map_width = 96 + (get_parent().get_map_width()*8)
	map_height = get_parent().get_map_height()*8
