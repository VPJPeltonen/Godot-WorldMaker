extends Sprite

export(Resource) var arrow
export(Resource) var diagonal_arrow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_direction(direction):
	if [2,4,6,8].has(direction):
		texture = diagonal_arrow
		if direction == 4 or direction == 6:
			scale.y = -0.25
		if direction == 6 or direction == 8:
			scale.x = -0.25
		#rotation_degrees = direction-2 * 22
	else:
		texture = arrow
