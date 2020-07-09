extends Camera2D

signal zoom_amount(amount)
signal camera_position(c_position)

onready var screen_edges = get_viewport().size
var scroll_speed = 25
var scroll_distance = 50
var locked = false

func _process(delta):
	if locked: return
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
		
	var direction = Vector2()
	if Input.is_action_pressed("pan_up"):
		direction.y -= scroll_speed/2
	elif Input.is_action_pressed("pan_down"):
		direction.y += scroll_speed/2
	
	if Input.is_action_pressed("pan_left"):
		direction.x -= scroll_speed/2
	elif Input.is_action_pressed("pan_right"):
		direction.x += scroll_speed/2
	
	position += direction
	

func move_to_export_pos(map_pos,map_width):
	if map_width == 192:
		set_zoom(Vector2(1.5,1.5))
		position = Vector2(map_pos.x+(get_viewport().size.x/1.32)-4,
				map_pos.y+(get_viewport().size.y/1.32)-4)
	else:
		set_zoom(Vector2(1,1))
		position = Vector2(map_pos.x+(get_viewport().size.x/2)-4,
						map_pos.y+(get_viewport().size.y/2)-4)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				var value = get_zoom() - Vector2(0.1,0.1)
				set_zoom(value)
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				var value = get_zoom() + Vector2(0.1,0.1)
				set_zoom(value)
			emit_signal("zoom_amount",get_zoom())
			
func _on_Map_map_generated():
	var main = get_parent()
	var map_size = main.get_map_size()
	var node_scale = main.get_node_scale()
	screen_edges.x = map_size.x * node_scale + 450
	screen_edges.y = map_size.y * node_scale + 200
