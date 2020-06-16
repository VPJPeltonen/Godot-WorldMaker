extends Sprite

signal node_info(elevation)
signal civ_info(elevation)

var map_generated = false
var map_width
var map_height
var node_size

onready var main = get_parent()

func _process(delta):
	if !map_generated:
		hide()
		return
	position.x = get_global_mouse_position().x - fmod(get_global_mouse_position().x,node_size) + 8
	position.y = get_global_mouse_position().y - fmod(get_global_mouse_position().y,node_size) + 4
	var X = (position.x-104)/node_size
	var Y = (position.y-4)/node_size
	if position.x > 96 and global_position.x < map_width+1 and global_position.y < map_height-1 and global_position.y > 0:
		show()
		var info = main.get_node_info(X,Y)
		var civ_info = main.get_civ_info(X,Y)
		emit_signal("node_info", info, X, Y)
		emit_signal("civ_info", civ_info)
	else:
		hide()
		
func _on_Map_map_generated():
	map_generated = true
	node_size = main.get_node_scale()
	map_width = 96 + (get_parent().get_map_width()*node_size)
	map_height = get_parent().get_map_height()*node_size
