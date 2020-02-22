extends Camera2D

var scroll_speed = 25

func _process(delta):
	if get_viewport().get_mouse_position().x >= get_viewport().size.x-25:
		position.x += scroll_speed
	if get_viewport().get_mouse_position().x <= 25:
		position.x -= scroll_speed
	if get_viewport().get_mouse_position().y >= get_viewport().size.y-25:
		position.y += scroll_speed
	if get_viewport().get_mouse_position().y <= 25:
		position.y -= scroll_speed
