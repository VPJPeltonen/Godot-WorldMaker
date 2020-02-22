extends Camera2D

var scroll_speed = 25
var scroll_distance = 50

func _process(delta):
	var x_distance = get_viewport().size.x - get_viewport().get_mouse_position().x
	var y_distance = get_viewport().size.y - get_viewport().get_mouse_position().y
	if x_distance <= scroll_distance:
		position.x += scroll_speed * ((scroll_distance-x_distance)/scroll_distance)
	if get_viewport().get_mouse_position().x <= scroll_distance:
		position.x -= scroll_speed * ((scroll_distance-get_viewport().get_mouse_position().x)/scroll_distance)
	if y_distance <= scroll_distance:
		position.y += scroll_speed * ((scroll_distance-y_distance)/scroll_distance)
	if get_viewport().get_mouse_position().y <= scroll_distance:
		position.y -= scroll_speed * ((scroll_distance-get_viewport().get_mouse_position().y)/scroll_distance)
