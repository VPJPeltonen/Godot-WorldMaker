extends Node2D

signal map_generated

export(Resource) var node
export(Resource) var continent

var nodes = []
var nodes_2 = []
var nodes_3 = []
var nodes_4 = []
var continents_array = []

var node_scale = 8
var rng = RandomNumberGenerator.new()
var map_generated = false

var continents = 9
var sea_level = 9
var width = 116
var height = 76

func _ready():
	rng.randomize()

func get_quarter(quarter):
	match quarter:
		1: return nodes
		2: return nodes_2
		3: return nodes_3
		4: return nodes_4

func get_sea_level():
	return sea_level
	
func get_node_elevation(nodeX,nodeY):
	if map_generated:
		var quarter
		if nodeX < width/2 and nodeY < height/2-1:
			quarter = get_quarter(1)
		elif nodeX >= width/2 and nodeY < height/2-1:
			nodeX = nodeX - width/2
			quarter = get_quarter(2)
			
		elif nodeX < width/2 and nodeY >= height/2-1:
			nodeY = nodeY - (height/2)
			quarter = get_quarter(3)
			
			
		else:
			nodeX = nodeX - width/2
			nodeY = nodeY - height/2
			quarter = get_quarter(4)
		var row = quarter[nodeX]
		return row[nodeY+1].ground_level
	else:
		return 0

func make_continents():
	continents = get_parent().get_continent_amount()
	for i in range(continents):
		var source = find_empty(i)
		var new_continent = continent.instance()
		add_child(new_continent)
		new_continent.init(i,source)
		continents_array.append(new_continent)
	var spreading = true
	while spreading:
		spreading = false
		for continent in continents_array:
			if continent.spread():
				spreading = true
	for row in nodes:
		for node in row:
			node.set_conflictzone()
	for row in nodes_2:
		for node in row:
			node.set_conflictzone()
	for row in nodes_3:
		for node in row:
			node.set_conflictzone()
	for row in nodes_4:
		for node in row:
			node.set_conflictzone()

func make_nodes():
	nodes = make_quarter(0,0,1)
	nodes_2 = make_quarter((width/2),0,2)
	nodes_3 = make_quarter(0,(height/2),3)
	nodes_4 = make_quarter((width/2),(height/2),4)
	set_neighbours()
	make_continents()
	#smooth_elevations()
	
func smooth_elevations():
	for row in nodes:
		for node in row:
			node.smooth_elevation()
	for row in nodes_2:
		for node in row:
			node.smooth_elevation()
	for row in nodes_3:
		for node in row:
			node.smooth_elevation()
	for row in nodes_4:
		for node in row:
			node.smooth_elevation()
	
func set_neighbours():
	quarter_neighbours(nodes)
	quarter_neighbours(nodes_2)
	quarter_neighbours(nodes_3)
	quarter_neighbours(nodes_4)

func quarter_neighbours(array):
	for row in array:
		for node in row:
			node.find_neighbours()

func make_quarter(imod,jmod,quarter):
	var quarter_nodes = []
	for i in range(width/2):
		var slice = []
		for j in range(height/2):
			var elevation = rng.randi_range(0,2)
			var new_node = node.instance()
			add_child(new_node)
			new_node.init(i+imod,j+jmod,node_scale,quarter,elevation)
			slice.append(new_node)
		quarter_nodes.append(slice)
	return quarter_nodes

func find_empty(i):
	while true:
		var quarter = rng.randi_range(1,4)
		var a = rng.randi_range(0,width/2-1)
		var b = rng.randi_range(0,height/2-1)
		var row 
		match quarter:
			1: row = nodes[a]
			2: row = nodes_2[a]
			3: row = nodes_3[a]
			4: row = nodes_4[a]
		var node = row[b]
		if node.continent == null:
			node.set_continent(i)
			return node

func _on_generate_button_pressed():
	#clear_map()
	if map_generated:
		get_tree().reload_current_scene()
	else:
		make_nodes()
		for i in range(0,2):
			smooth_elevations()
		color_nodes("sea")
		map_generated = true
		emit_signal("map_generated")

func _on_Continent_mode_button_pressed():
	color_nodes("continent")

func _on_Conflict_mode_button_pressed():
	color_nodes("continentconflict")
	
func _on_Elevation_mode_button_pressed():
	color_nodes("elevation")
	
func _on_Sea_mode_button_pressed():
	color_nodes("sea")
	
func color_nodes(mode):
	for row in nodes:
		for node in row:
			node.color_mode(mode)
	for row in nodes_2:
		for node in row:
			node.color_mode(mode)
	for row in nodes_3:
		for node in row:
			node.color_mode(mode)
	for row in nodes_4:
		for node in row:
			node.color_mode(mode)

func _on_smooth_button_pressed():
	smooth_elevations()
	color_nodes("elevation")

func _on_apply_settings_button_pressed():
	sea_level = get_parent().get_sea_level()
	color_nodes("sea")

func _on_size_button_pressed(size):
	match size:
		"small":
			width = 64
			height = 48
		"medium":
			width = 116
			height = 76
		"large":
			width = 156
			height = 112

