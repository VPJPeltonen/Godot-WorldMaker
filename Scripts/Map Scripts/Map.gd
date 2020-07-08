extends Node2D

signal map_generated
signal node_action(action,data)
signal show_river(toggle)
signal reset_river

export(Resource) var node
export(Resource) var continent
export(Resource) var river

onready var main = get_parent()

var creation_thread
var adjust_thread

var state = "none"
var display_mode

var nodes = []
var nodes_2 = []
var nodes_3 = []
var nodes_4 = []
var continents_array = []
var rivers_array = []

var node_scale = 8
var map_generated = false

var continents
var sea_level = 9
var width = 128
var height = 80

func _process(delta):
	match state:
		"start generating":
			creation_thread = Thread.new()
			creation_thread.start(self, "_creation")
			state = "generating"
			
func get_quarter(quarter):
	match quarter:
		1: return nodes
		2: return nodes_2
		3: return nodes_3
		4: return nodes_4

func get_sea_level():
	return sea_level

func get_civs():
	return get_node("Civilizations").civs

func get_map_node(nodeX,nodeY):
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
		if nodeY+1 <= row.size():
			return row[nodeY]
		else:
			return 0
	else:
		return 0
	
func get_node_info(nodeX,nodeY):
	var n = get_map_node(nodeX,nodeY)
	if typeof(n) == 17:
		return n.get_info()
	else:
		return 0
			
func get_civ_info(nodeX,nodeY):
	var n = get_map_node(nodeX,nodeY)
	if typeof(n) == 17:
		return n.get_civ_info()
	else:
		return 0

func get_map_info():
	var info = "Width: " + str(width)
	info += "\nHeight: " + str(height)
	info += "\nSeed: " + str(randomizer.seed_string)
	info += "\nSea level: " + str(sea_level)
	return info

func make_quarter(imod,jmod,quarter,nodescale):
	var quarter_nodes = []
	for i in range(width/2):
		var slice = []
		for j in range(height/2):
			var elevation = randomizer.rng.randf_range(0,2)
			var new_node = node.instance()
			add_child(new_node)
			new_node.init(i+imod,j+jmod,nodescale,quarter,elevation)
			connect('node_action', new_node, '_on_node_action')
			slice.append(new_node)
		quarter_nodes.append(slice)
	return quarter_nodes
	
func make_continents():
	continents = main.get_continent_amount()
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
	for continent in continents_array:
			continent.set_height()
	emit_signal("node_action","set_conflictzone","none")
	
func find_empty(i):
	while true:
		var quarter = randomizer.rng.randi_range(1,4)
		var a = randomizer.rng.randi_range(0,width/2-1)
		var b = randomizer.rng.randi_range(0,height/2-1)
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

func smooth_node_values(target,top_value):
	for i in range(0,top_value):
		var min_ele = top_value-i-0.5
		var max_ele = top_value-i+0.5
		emit_signal("node_action",target,[min_ele,max_ele])

func color_nodes(mode):
	emit_signal("node_action","change_color_mode",mode)
	display_mode = mode

func toggle_shadows(on):
	emit_signal("node_action", "toggle_shadows", on)

func make_geology():
	smooth_node_values("smooth_elevation_differences",30)
	for i in range(3):
		emit_signal("node_action","erosion","none")
	for i in range(5):
		emit_signal("node_action","water_erosion","none")
	emit_signal("node_action","erosion","none")
	emit_signal("node_action", "set_ground_level","none")

func new_river(node):
	var new_river = river.instance()
	add_child(new_river)
	new_river.init(0,node,global_position)
	connect('show_river', new_river, '_on_show_river')
	connect('reset_river', new_river, '_on_reset_river')
	rivers_array.append(new_river)

func make_rivers():
	for i in range(0,9):
		var min_ele = 12-i-0.5
		var max_ele = 12-i+0.5
		emit_signal("node_action","create_rivers",[min_ele,max_ele])

func make_climate():
	emit_signal("node_action","set_sea_rainfall","none")
	emit_signal("node_action","set_mountain_rainfall","none")
	emit_signal("node_action","set_winds","none")
	smooth_node_values("set_wind_rainfall",20)
	make_rivers()
	smooth_node_values("spread_rainfall",12)
	emit_signal("node_action","set_basic_temperature","none")
	smooth_node_values("set_wind_temperature",7)
	emit_signal("node_action", "set_climate", "none")

func make_nodes():
	nodes = make_quarter(0,0,1,node_scale)
	nodes_2 = make_quarter((width/2),0,2,node_scale)
	nodes_3 = make_quarter(0,(height/2),3,node_scale)
	nodes_4 = make_quarter((width/2),(height/2),4,node_scale)

func _creation(userdata):
	randomizer.set_seed(main.get_map_seed())
	main.set_info_label("Building Map Nodes")
	make_nodes()
	emit_signal("node_action","find_neighbours","none")
	main.set_info_label("Making Continents")
	make_continents()
	color_nodes("continent")
	main.set_info_label("Making Geology")
	make_geology()
	main.set_info_label("Making Climate")
	color_nodes("sea")
	make_climate()
	main.set_info_label("")
	color_nodes("satellite")
	main.view_mode()
	map_generated = true
	state = "none"
	emit_signal("map_generated")

func _adjust(userdata):
	main.disable_buttons()
	emit_signal("node_action",userdata[0],"none")
	emit_signal("node_action","reset","none")
	emit_signal("node_action", "set_ground_level","none")
	make_climate()
	color_nodes(userdata[1])
	main.enable_buttons()

func _change_sealevel(userdata):
	main.disable_buttons()
	sea_level = main.get_sea_level()
	emit_signal("node_action","reset","none")
	emit_signal("reset_river")
	emit_signal("node_action", "set_ground_level","none")
	make_climate()
	color_nodes(display_mode)
	main.enable_buttons()

func _add_detail(userdata):
	main.disable_buttons()
	main.set_info_label("Adding Detail")
	emit_signal("node_action","add_detail","none")
	main.set_info_label(" ")
	main.enable_buttons()
	emit_signal("node_action","change_color_mode","satellite")
	
func _on_generate_button_pressed():
	if map_generated: get_tree().reload_current_scene()
	elif state == "none": state = "start generating"
	
func _on_color_mode_button_pressed(mode):
	color_nodes(mode)
	$guide.view(mode)
	
func _on_smooth_button_pressed():
	creation_thread = Thread.new()
	creation_thread.start(self, "_adjust",["erosion","sea"])
	
func _on_smooth_ele_button_pressed():
	smooth_node_values("smooth_elevation_differences",30)
	color_nodes("elevation")
	
func _on_water_erosion_button_pressed():
	creation_thread = Thread.new()
	creation_thread.start(self, "_adjust",["water_erosion","sea"])
	
func _on_apply_settings_button_pressed():
	if !creation_thread.is_active():
		creation_thread = Thread.new()
		creation_thread.start(self, "_change_sealevel")
	else:
		adjust_thread = Thread.new()
		adjust_thread.start(self, "_change_sealevel")

func _on_size_button_pressed(size):
	match size:
		"small":
			width = 80
			height = 50
		"medium":
			width = 128
			height = 80
		"large":
			width = 192
			height = 120

func _on_Wind_mode_button_pressed():
	emit_signal("node_action","show_wind","none")

func _on_reset_nodes_button_pressed():
	emit_signal("node_action","reset","none")

func _on_show_rivers_button_toggled(button_pressed):
	emit_signal("show_river",button_pressed)

func _on_init_civs_pressed():
	var amount = main.get_civ_amount()
	get_node("Civilizations").make_civs(amount)

func _on_adjust_done_button_pressed():
	if !creation_thread.is_active():
		creation_thread = Thread.new()
		creation_thread.start(self, "_add_detail")
	else:
		adjust_thread = Thread.new()
		adjust_thread.start(self, "_add_detail")
