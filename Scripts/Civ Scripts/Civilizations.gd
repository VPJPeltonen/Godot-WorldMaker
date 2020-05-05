extends Node2D

export(Resource) var civ
signal show_civs

var civs = []
var rng = RandomNumberGenerator.new()
var creation_thread
var civs_amount

onready var map = get_parent()

func make_civs(amount):
	civs_amount = amount
	for i in range(civs_amount):
		var new_civ = civ.instance()
		var start_node = find_empty(i)
		add_child(new_civ)
		new_civ.init_civ(start_node,i)
		civs.append(new_civ)
	spread_civs()


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

func spread_civs():
	var spreading = true
	while spreading:
		spreading = false
		for c in civs:
			if c.spread():
				spreading = true
	emit_signal("show_civs")
		
