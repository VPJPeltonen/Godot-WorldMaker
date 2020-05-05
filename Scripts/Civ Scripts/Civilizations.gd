extends Node2D

export(Resource) var civ

onready var map = get_parent()
var rng = RandomNumberGenerator.new()

func make_civs(amount):
	for i in range(amount):
		var new_civ = civ.instance()
		var start_node = find_empty(i)
		add_child(new_civ)
		new_civ.init_civ(start_node,i)
		
func find_empty(i):
	while true:
		var quarter = rng.randi_range(1,4)
		var a = rng.randi_range(0,map.width/2-1)
		var b = rng.randi_range(0,map.height/2-1)
		var row 
		match quarter:
			1: row = map.nodes[a]
			2: row = map.nodes_2[a]
			3: row = map.nodes_3[a]
			4: row = map.nodes_4[a]
		var node = row[b]
		if node.owning_civ == null and node.ground_level >= 0:
			return node
