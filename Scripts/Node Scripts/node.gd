extends Sprite

export(Resource) var sub_node

var continent
var slide_direction = 0
var conflictzone = false

# climate stuff
var arability = 0.0
var rainfall = 0.0
var wind_direction = 0
var temperature = 0
var elevation = 0.0
var ground_level = 0.0
var sea_level = 0.0
var climate = ""
var river = "none"
var lake = false

# civ stuff
var owning_civ

var creation_thread
var X
var Y
var quarter
var neighbours = []
var neighbours_directions = []
var node_scale = 8

func set_civ(new_owner):
	owning_civ = new_owner
	for node in get_node("node_sprite").get_children():
		node.owning_civ = new_owner

func get_neighbours():
	return neighbours

func toggle_shadows(on):
	if on: $elevation_shadow.show()
	else: $elevation_shadow.hide()

func get_info():
	var dict = {
		"ground_level":ground_level,
		"rainfall":rainfall,
		"wind_direction":wind_direction,
		"temperature":temperature,
		"climate":climate
	}
	return dict

func init(x_pos,y_pos,node_scale,Quarter,new_elevation):
	position = Vector2(x_pos*node_scale,y_pos*node_scale)
	X = x_pos
	Y = y_pos
	quarter = Quarter
	elevation = new_elevation

func add_detail():
	for i in range(4):
		var new_node = sub_node.instance()
		get_node("node_sprite").add_child(new_node)
		match i:
			0: new_node.set_global_position(Vector2(position.x+102,position.y+1))
			1: new_node.set_global_position(Vector2(position.x+106,position.y+1))
			2: new_node.set_global_position(Vector2(position.x+102,position.y+5))
			3: new_node.set_global_position(Vector2(position.x+106,position.y+5))
		new_node.init_sub_sprite(self)

# wind
func set_wind():
	var map_height = get_parent().height
	if Y < map_height/4:
		wind_direction = 2
	elif Y < map_height/2:
		wind_direction = 6
	elif Y < map_height - map_height/4:
		wind_direction = 8
	else:
		wind_direction = 4
	#set_wind_arrow()

func set_wind_arrow():
	pass #$wind_arrow.set_direction(wind_direction)
	
# elevation
func set_ground_level():
	sea_level = get_parent().get_sea_level()
	ground_level = elevation-sea_level
	
func erosion():
	var average_elevation = 0
	for node in neighbours:
		average_elevation += node.elevation
	average_elevation = average_elevation/neighbours.size()
	elevation = (elevation+elevation+average_elevation)/3

func water_erosion():
	if ground_level <= 0.2:
		var average_elevation = 0
		for node in neighbours:
			average_elevation += node.elevation
		average_elevation = average_elevation/neighbours.size()
		elevation = (elevation+elevation+average_elevation)/3
		
func smooth_elevation_differences(elevation_checked_min,elevation_checked_max):
	if elevation > elevation_checked_min and elevation <= elevation_checked_max:
		for node in neighbours:
			if node.elevation < elevation:
				node.elevation = max(elevation - 3,node.elevation)

func set_conflictzone():
	for node in neighbours:
		if node.continent != continent:
			conflictzone = true
			set_conflict_type(node)
			
func set_conflict_type(other_node):
	var collission_dir = [(slide_direction+3)%8+1]
	var retreat_dir = [slide_direction,slide_direction%8+1]
	if slide_direction == 1: retreat_dir.append(8)
	else: retreat_dir.append(slide_direction-1)
	if collission_dir.has(neighbours.find(other_node)):
		elevation += 8
		other_node.elevation += 8
	if retreat_dir.has(neighbours.find(other_node)):
		elevation -= 8
		other_node.elevation -= 8
			
# rainfall
func set_sea_rainfall():
	if ground_level < 0:
		for node in neighbours:
			if node.ground_level > 0:
				node.rainfall += 0.9
				rainfall += 0.9

func set_mountain_rainfall():
	var higher_neighbours = 0
	for node in neighbours:
		if node.elevation > elevation+0.5:
			rainfall += 1

func set_wind_rain(min_value,max_value):
	if rainfall > min_value and rainfall < max_value:
		var wind_node = neighbours[neighbours_directions.find(wind_direction)]
		wind_node.rainfall += rainfall/2

func spread_rainfall(rainfall_checked_min,rainfall_checked_max):
	if rainfall > rainfall_checked_min and rainfall <= rainfall_checked_max:
		for node in neighbours:
			if node.rainfall < rainfall:
				node.rainfall = max(rainfall - 1.5,node.rainfall)

# temperature
func set_wind_temperature(min_value,max_value):
	if temperature > min_value and temperature <= max_value:
		var wind_node = neighbours[neighbours_directions.find(wind_direction)]
		wind_node.temperature = (temperature+wind_node.temperature)/2
	
func set_basic_temperature():
	var world_height = get_parent().height
	var slice = world_height/14
	if (Y >= 0 and Y <= slice*2) or (Y >= world_height - slice*2):
		temperature = 0.0
	elif (Y > slice*2 and Y <= slice*3) or (Y > world_height - (slice*3) and Y <= world_height - slice*2):
		temperature = 1.0
	elif (Y > slice*3 and Y <= slice*4) or (Y > world_height - (slice*4) and Y <= world_height - slice*3):
		temperature = 2.0
	elif (Y > slice*4 and Y <= slice*5) or (Y > world_height - (slice*5) and Y <= world_height - slice*4):
		temperature = 3.0
	elif (Y > slice*5 and Y <= slice*6) or (Y > world_height - (slice*6) and Y <= world_height - slice*5):
		temperature = 4.0
	elif (Y > slice*6 and Y <= slice*7) or (Y > world_height - (slice*7) and Y <= world_height - slice*6):
		temperature = 5.0
	else:
		temperature = 6.0
	elevation_temperature_adjustment()

func elevation_temperature_adjustment():
	if ground_level > 2:
		temperature -= ground_level/2

func set_arability():
	arability = 0.0

# climate
func set_climate():
	if ground_level < 0:
		if temperature == 0 and rainfall >= 3:
			climate = "Ice Cap"
		else:
			if ground_level >= -1: climate = "Coastal Sea"
			elif ground_level >= -2: climate = "Sea"
			else: climate = "Deep Sea"
	else:
		if lake:
			climate = "Lake"
		elif temperature == 0:
			if rainfall <= 1: climate = "Polar Desert"
			elif rainfall <= 2: climate = "Polar Desert"
			elif rainfall <= 3: climate = "Polar Desert"
			elif rainfall <= 4: climate = "Ice Cap"
			elif rainfall <= 5: climate = "Ice Cap"
			elif rainfall <= 6: climate = "Ice Cap"
			elif rainfall <= 7: climate = "Ice Cap"	
			else: climate = "Ice Cap"
		elif temperature <= 1:
			if rainfall <= 1: climate = "Polar Desert"
			elif rainfall <= 2: climate = "Polar Desert"
			elif rainfall <= 3: climate = "Polar Desert"
			elif rainfall <= 4: climate = "Tundra"
			elif rainfall <= 5: climate = "Tundra"
			elif rainfall <= 6: climate = "Wet Tundra"
			elif rainfall <= 7: climate = "Wet Tundra"	
			else: climate = "Polar Wetlands"
		elif temperature <= 2:
			if rainfall <= 1: climate = "Cool Desert"
			elif rainfall <= 2: climate = "Cool Desert"
			elif rainfall <= 3: climate = "Steppe"
			elif rainfall <= 4: climate = "Boreal Forest"
			elif rainfall <= 5: climate = "Boreal Forest"
			elif rainfall <= 6: climate = "Boreal Forest"
			elif rainfall <= 7: climate = "Boreal Forest"	
			else: climate = "Polar Wetlands"	
		elif temperature <= 3:
			if rainfall <= 1: climate = "Cool Desert"
			elif rainfall <= 2: climate = "Cool Desert"
			elif rainfall <= 3: climate = "Steppe"
			elif rainfall <= 4: climate = "Temperate Woodlands"
			elif rainfall <= 5: climate = "Temperate Woodlands"
			elif rainfall <= 6: climate = "Temperate Forest"
			elif rainfall <= 7: climate = "Temperate Wet Forest"
			else: climate = "Temperate Wetlands"
		elif temperature <= 4:
			if rainfall <= 1: climate = "Extreme Desert"
			elif rainfall <= 2: climate = "Desert"
			elif rainfall <= 3: climate = "Subtropical Scrub"
			elif rainfall <= 4: climate = "Subtropical Woodlands"
			elif rainfall <= 5: climate = "Mediterranean"
			elif rainfall <= 6: climate = "Temperate Forest"
			elif rainfall <= 7: climate = "Temperate Wet Forest"
			else: climate = "Temperate Wetlands"
		elif temperature <= 5:
			if rainfall <= 1: climate = "Extreme Desert"
			elif rainfall <= 2: climate = "Desert"
			elif rainfall <= 3: climate = "Subtropical Scrub"
			elif rainfall <= 4: climate = "Subtropical Woodlands"
			elif rainfall <= 5: climate = "Subtropical Dry Forest"
			elif rainfall <= 6: climate = "Subtropical Forest"
			elif rainfall <= 7: climate = "Subtropical Wet Forest"	
			else: climate = "Subtropical Wetlands"
		else:
			if rainfall <= 1: climate = "Extreme Desert"
			elif rainfall <= 2: climate = "Desert"
			elif rainfall <= 3: climate = "Tropical Scrub"
			elif rainfall <= 4: climate = "Tropical Woodlands"
			elif rainfall <= 5: climate = "Tropical Dry Forest"
			elif rainfall <= 6: climate = "Tropical Wet Forest"
			elif rainfall <= 7: climate = "Tropical Wet Forest"	
			else: climate = "Tropical Wetlands"

# node architecture
func find_neighbours():
	var nodes = get_parent().get_quarter(quarter)
	var quarterX = fmod(X,get_parent().width/2)
	var quarterY = fmod(Y,get_parent().height/2)
	#unless is left row
	if (quarterX != 0):  
		var row = nodes[quarterX-1]
		neighbours.append(row[quarterY])
		neighbours_directions.append(7)
	elif (quarter == 2 or quarter == 4):
		var left_quarter = get_parent().get_quarter(quarter-1)
		var row = left_quarter[-1]
		neighbours.append(row[quarterY])
		neighbours_directions.append(7)
	#unless top row
	if (quarterY != 0):
		var row = nodes[quarterX]
		neighbours.append(row[quarterY-1])
		neighbours_directions.append(1)
	elif(quarter == 3 or quarter == 4):
		var above_quarter = get_parent().get_quarter(quarter-2)
		var row = above_quarter[quarterX]
		neighbours.append(row[-1])
		neighbours_directions.append(1)
	#unless right row
	if (quarterX != get_parent().width/2-1):
		var row = nodes[quarterX+1]
		neighbours.append(row[quarterY])
		neighbours_directions.append(3)
	elif(quarter == 1 or quarter == 3):
		var right_quarter = get_parent().get_quarter(quarter+1)
		var row = right_quarter[0]
		neighbours.append(row[quarterY])
		neighbours_directions.append(3)
	#unless bottom row
	if (quarterY != get_parent().height/2-1):
		var row = nodes[quarterX]
		neighbours.append(row[quarterY+1])
		neighbours_directions.append(5)
	elif(quarter == 1 or quarter == 2):
		var below_row = get_parent().get_quarter(quarter+2)
		var row = below_row[quarterX]
		neighbours.append(row[0])
		neighbours_directions.append(5)
	#topleft
	if (!(quarterX == 0 || quarterY == 0)):
		var row = nodes[quarterX-1]
		neighbours.append(row[quarterY-1])
		neighbours_directions.append(8)
	elif(quarter == 4 and quarterX == 0 and quarterY == 0):
		var topleft_quarter = get_parent().get_quarter(1)
		var row = topleft_quarter[-1]
		neighbours.append(row[-1])
		neighbours_directions.append(8)
	#topright   
	if (!(quarterX == get_parent().width/2-1 || quarterY == 0)):
		var row = nodes[quarterX + 1]
		neighbours.append(row[quarterY - 1])
		neighbours_directions.append(2)
	elif(quarter == 3 and quarterX == get_parent().width/2-1 and quarterY == 0):
		var topright_quarter = get_parent().get_quarter(2)
		var row = topright_quarter[0]
		neighbours.append(row[-1])
		neighbours_directions.append(2)
	#bottomleft     
	if (!(quarterX == 0 || quarterY == get_parent().height/2-1)):
		var row = nodes[quarterX - 1] 
		neighbours.append(row[quarterY + 1])
		neighbours_directions.append(6)
	elif(quarter == 2 and quarterX == 0 and quarterY == get_parent().height/2-1):
		var bottomleft_quarter = get_parent().get_quarter(3)
		var row = bottomleft_quarter[-1]
		neighbours.append(row[0])
		neighbours_directions.append(6)
	#bottomright
	if (!(quarterX == get_parent().width/2-1 || quarterY == get_parent().height/2-1)):
		var row = nodes[quarterX + 1]
		neighbours.append(row[quarterY + 1])
		neighbours_directions.append(4)
	elif(quarter == 1 and quarterX == get_parent().width/2-1 and quarterY == get_parent().height/2-1):
		var bottomright_quarter = get_parent().get_quarter(4)
		var row = bottomright_quarter[0]
		neighbours.append(row[0])
		neighbours_directions.append(4)

func set_continent(new_continent):
	continent = new_continent

func color_mode(mode):
	match mode:
		"civilizations":
			if owning_civ == null:
				$node_sprite.color_mode("blank",ground_level)
			else:
				$node_sprite.color_mode("civilization",owning_civ.civ_color)
		"climate": 
			set_z(ground_level)
			$node_sprite.color_mode("climate",climate)
		"continent": $node_sprite.color_mode("continent",continent)
		"continentconflict": $node_sprite.color_mode("continentconflict",conflictzone)
		"elevation": 
			set_z(ground_level)
			$node_sprite.color_mode("elevation",elevation)	
		"rainfall": $node_sprite.color_mode("rainfall",rainfall)
		"satellite": $node_sprite.color_mode("satellite",climate)
		"sea": 
			set_z(ground_level)
			$node_sprite.color_mode("sea",ground_level)
		"temperature": $node_sprite.color_mode("temperature",temperature)
		"blank": $node_sprite.color_mode("blank",ground_level)

func set_z(value):
	if ground_level < 0: return
	var modifier
	if value >= 0:
		if value < 3:
			if value < 0.2: modifier = 2.0
			elif value < 0.4: modifier = 4.0
			elif value < 0.6: modifier = 6.0
			elif value < 1.0: modifier = 8.0
			elif value < 1.5: modifier = 10.0
			elif value < 2.2: modifier = 12.0
			else: modifier = 14.0
		else:
			if value > 12.0: modifier = 32.0
			else: modifier = value*2+8
	elif value >= -1: modifier = 0.0
	elif value >= -2: modifier = -2.0
	else: modifier = -4.0
	var alpha = 1-max(((modifier*2)/100)+0.4,0)
	#z_index = modifier
	#$overlay_shadow.set_self_modulate(Color(0.2,0.2,0.2,alpha))

func reset():
	rainfall = 0
	ground_level = 0
	temperature = 0
	climate = "Sea"
	river = "none"
	lake = false

func create_rivers(min_rain,max_rain):
	for node in neighbours:
		if node.ground_level <= 0: return
		if node.river != "none": return
	if rainfall > min_rain and rainfall <= max_rain and river == "none":
		get_parent().new_river(self)

func toggle_river():
	if river != "none":
		$river.show_river(1,5,node_scale)

func _on_node_action(action,data):
	match action:
		"add_detail": add_detail()
		"find_neighbours": find_neighbours()
		"change_color_mode": color_mode(data)
		"create_rivers": create_rivers(data[0],data[1])
		"set_basic_temperature": set_basic_temperature()
		"set_climate": set_climate()
		"set_conflictzone": set_conflictzone()
		"set_ground_level": set_ground_level()
		"set_mountain_rainfall": set_mountain_rainfall()
		"set_sea_rainfall": set_sea_rainfall()
		"set_wind_rainfall": set_wind_rain(data[0],data[1])
		"set_wind_temperature": set_wind_temperature(data[0],data[1])
		"set_winds": set_wind()
		"show_rivers": toggle_river()
		"spread_rainfall": spread_rainfall(data[0],data[1])
		"toggle_shadows": toggle_shadows(data)
		"water_erosion": water_erosion()
		"erosion": erosion()
		"smooth_elevation_differences": smooth_elevation_differences(data[0],data[1])
		"show_wind": pass#$wind_arrow.visible = !$wind_arrow.visible
		"reset": reset()
