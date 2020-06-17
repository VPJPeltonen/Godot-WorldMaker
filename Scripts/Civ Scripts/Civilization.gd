extends Node2D

export(Resource) var Flag

var civ_name = "Generic Civ"
var capital
var area = []
var spreadable_area = []
var civ_color
var rng = RandomNumberGenerator.new()

func init_civ(node,num):
	capital = node
	civ_color = num
	capital.set_civ(self)
	area.append(node)
	generate_name()
	spreadable_area.append(node)
	var new_node = Flag.instance()
	add_child(new_node)

func spread():
	var new_nodes = []
	for node in spreadable_area:
		var spreadable = false
		var neighbours = node.get_neighbours()
		for node in neighbours:
			if node.owning_civ == null and node.ground_level >= -0.2:
				spreadable = true
				var flip = rng.randi_range(0,1)
				if flip == 1:
					node.set_civ(self)
					new_nodes.append(node)
		if !spreadable:
			spreadable_area.remove(spreadable_area.find(node))
	for node in new_nodes:
		area.append(node)
		spreadable_area.append(node)
	if spreadable_area.size() == 0:
		return false
	else:
		return true

func get_flag():
	return get_node("flag")

func generate_name():
	civ_name = ""
	rng.randomize()
	var names = json_reader.get_civ_names()
	var type_chance = rng.randi_range(0,3)
	var governments = names["governments"]
	if(type_chance == 1):
		governments = governments["rare"]
	else:
		governments = governments["common"]
	civ_name += governments[str(rng.randi_range(0,governments.size()-1))] + " of "
	var first_part = names["part one"]
	var second_part = names["part two"]
	civ_name += first_part[str(rng.randi_range(0,first_part.size()-1))] + second_part[str(rng.randi_range(0,second_part.size()-1))]
