extends Sprite

var initialized

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	#draw_list = [Vector2(0, 0), Vector2(250, 10), Vector2(50, 300), Vector2(500, 500)]

func _fixed_process(delta):
	pass

func _process(delta):
	update()
	
func _draw():
	draw_line(Vector2(0,0), Vector2(50, 50), Color(255, 0, 0), 1)
	
func show_river(upstream,downstream,node_scale):
	if visible:
		hide()
	else:
		show()
#		var origin = get_direction(upstream,node_scale)
#		var destination = get_direction(downstream,node_scale)
#		#draw_line(origin, destination, Color(0,1,1,1), 3, false )
#		draw_line(Vector2(0,0), Vector2(500,500), Color(0,1,1,1), 3, false )
		
func get_direction(number,node_scale):
	var pos
	match number:
		1: pos = Vector2(position.x+node_scale/2,position.y+0)
		2: pos = Vector2(node_scale,0)
		3: pos = Vector2(node_scale,node_scale/2)
		4: pos = Vector2(node_scale,node_scale)
		5: pos = Vector2(position.x+node_scale/2,position.y+node_scale)
		6: pos = Vector2(0,node_scale)
		7: pos = Vector2(0,node_scale/2)
		8: pos = Vector2(0,0)
	return pos
	
#void draw_line ( Vector2 from, Vector2 to, Color color, float width=1.0, bool antialiased=false )
#
#Draws a line from a 2D point to another, with a given color and width. It can be optionally antialiased.
