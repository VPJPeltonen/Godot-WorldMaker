extends Node

var id_number = 0
var nodes = []
var spreadable_nodes = []
var rng = RandomNumberGenerator.new()

var base_elevation = 0
var float_direction

func _ready():
	rng.randomize()

func init(new_id,new_source):
	id_number = new_id
	base_elevation = rng.randi_range(7,9)
	nodes.append(new_source)
	spreadable_nodes.append(new_source)
	new_source.elevation += base_elevation
	float_direction = rng.randi_range(1,8)

func spread():
	var new_nodes = []
	for node in spreadable_nodes:
		var spreadable = false
		var neighbours = node.get_neighbours()
		for node in neighbours:
			if node.continent == null:
				spreadable = true
				var flip = rng.randi_range(0,1)
				if flip == 1:
					node.set_continent(id_number)
					node.elevation += base_elevation
					node.slide_direction = float_direction
					new_nodes.append(node)
		if !spreadable:
			spreadable_nodes.remove(spreadable_nodes.find(node))
	for node in new_nodes:
		nodes.append(node)
		spreadable_nodes.append(node)
	if spreadable_nodes.size() == 0:
		return false
	else:
		return true
