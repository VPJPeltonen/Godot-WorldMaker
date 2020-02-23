extends Camera2D

onready var screen_edges = get_viewport().size
var scroll_speed = 25
var scroll_distance = 50

func _process(delta):
	var x_distance = get_viewport().size.x - get_viewport().get_mouse_position().x
	var y_distance = get_viewport().size.y - get_viewport().get_mouse_position().y
	var mouse_position = get_global_mouse_position()
	var mouse_vieport = get_viewport().get_mouse_position()
	
	if x_distance <= scroll_distance and mouse_position.x < screen_edges.x:
		position.x += scroll_speed * ((scroll_distance-x_distance)/scroll_distance)
	if mouse_vieport.x <= scroll_distance and mouse_position.x > 0:
		position.x -= scroll_speed * ((scroll_distance-mouse_vieport.x)/scroll_distance)
	if y_distance <= scroll_distance and mouse_position.y < screen_edges.y:
		position.y += scroll_speed * ((scroll_distance-y_distance)/scroll_distance)
	if mouse_vieport.y <= scroll_distance and mouse_position.y > 0:
		position.y -= scroll_speed * ((scroll_distance-mouse_vieport.y)/scroll_distance)

func _on_Map_map_generated():
	var main = get_parent()
	var map_size = main.get_map_size()
	var node_scale = main.get_node_scale()
	screen_edges.x = map_size.x * node_scale + 200
	screen_edges.y = map_size.y * node_scale + 200
