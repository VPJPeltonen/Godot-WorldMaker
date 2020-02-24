extends Node2D

signal map_generated
signal node_action(action,data)

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
var width = 128
var height = 80

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
	
func get_node_info(nodeX,nodeY):
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
			return row[nodeY].get_info()
		else:
			return 0
	else:
		return 0
			
func make_quarter(imod,jmod,quarter):
	var quarter_nodes = []
	for i in range(width/2):
		var slice = []
		for j in range(height/2):
			var elevation = rng.randf_range(0,2)
			var new_node = node.instance()
			add_child(new_node)
			new_node.init(i+imod,j+jmod,node_scale,quarter,elevation)
			connect('node_action', new_node, '_on_node_action')
			slice.append(new_node)
		quarter_nodes.append(slice)
	return quarter_nodes
	
func make_nodes():
	nodes = make_quarter(0,0,1)
	nodes_2 = make_quarter((width/2),0,2)
	nodes_3 = make_quarter(0,(height/2),3)
	nodes_4 = make_quarter((width/2),(height/2),4)
	set_neighbours()
	make_continents()	
				
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
	for continent in continents_array:
			continent.set_height()
	emit_signal("node_action","set_conflictzone","none")
	
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
			

func smooth_elevations_differences():
	for i in range(0,30):
		var min_ele = 30-i-0.5
		var max_ele = 30-i+0.5
		emit_signal("node_action","smooth_elevation_differences",[min_ele,max_ele])

func set_wind_rainfall():
	for i in range(0,20):
		var min_value = 20-i-0.5
		var max_value = 20-i+0.5
		emit_signal("node_action","set_wind_rainfall",[min_value,max_value])
		
func set_wind_temperature():
	for i in range(0,7):
		var min_value = 7-i-0.5
		var max_value = 7-i+0.5
		emit_signal("node_action","set_wind_temperature",[min_value,max_value])
		
func set_winds():
	emit_signal("node_action","set_winds","none")

func erosion():
	emit_signal("node_action","erosion","none")

func water_erosion():
	emit_signal("node_action","water_erosion","none")

func set_sea_rainfall():
	emit_signal("node_action","set_sea_rainfall","none")

func set_mountain_rainfall():
	emit_signal("node_action","set_mountain_rainfall","none")

func set_temperatures():
	emit_signal("node_action","set_basic_temperature","none")

func set_neighbours():
	emit_signal("node_action","find_neighbours","none")

func color_nodes(mode):
	emit_signal("node_action","change_color_mode",mode)

func set_ground_level():
	emit_signal("node_action", "set_ground_level","none")

func set_climate():
	emit_signal("node_action", "set_climate", "none")

func toggle_shadows(on):
	emit_signal("node_action", "toggle_shadows", on)

func spread_rainfall():
	for i in range(0,12):
		var min_value = 12-i-0.5
		var max_value = 12-i+0.5
		emit_signal("node_action", "spread_rainfall",[min_value,max_value])

func make_geology():
	smooth_elevations_differences()
	for i in range(3):
		erosion()
	#color_nodes("sea")
	for i in range(5):
		water_erosion()
	erosion()
	set_ground_level()

func make_climate():
	set_sea_rainfall()
	set_mountain_rainfall()
	set_winds()
	set_wind_rainfall()
	spread_rainfall()
	set_temperatures()
	set_wind_temperature()
	set_climate()

func _on_generate_button_pressed():
	if map_generated:
		get_tree().reload_current_scene()
	else:
		make_nodes()
		make_geology()
		make_climate()
		color_nodes("sea")
		get_parent().view_mode()
		map_generated = true
		emit_signal("map_generated")

func _on_color_mode_button_pressed(mode):
	color_nodes(mode)
	
func _on_smooth_button_pressed():
	erosion()
	color_nodes("elevation")
	
func _on_smooth_ele_button_pressed():
	smooth_elevations_differences()
	color_nodes("elevation")
	
func _on_water_erosion_button_pressed():
	water_erosion()
	color_nodes("sea")
	
func _on_apply_settings_button_pressed():
	sea_level = get_parent().get_sea_level()
	set_ground_level()
	color_nodes("sea")

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
