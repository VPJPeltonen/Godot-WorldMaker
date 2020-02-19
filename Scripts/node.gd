extends Sprite

var continent
var slide_direction = 0
var conflictzone = false
var conflict_type = "none"

var rainfall = 0.0
var wind_direction = 0
var temperature = 0

var elevation = 0.0
var ground_level = 0.0
var sea_level = 0.0

var X
var Y
var quarter
var neighbours = []
var neighbours_directions = []

func get_neighbours():
	return neighbours

func init(x_pos,y_pos,node_scale,Quarter,new_elevation):
	position = Vector2(x_pos*node_scale,y_pos*node_scale)
	X = x_pos
	Y = y_pos
	quarter = Quarter
	elevation = new_elevation

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
	set_wind_arrow()

func set_wind_arrow():
	$wind_arrow.set_direction(wind_direction)

func set_ground_level():
	sea_level = get_parent().get_sea_level()
	ground_level = elevation-sea_level

func set_sea_rainfall():
	for node in neighbours:
		if node.ground_level < 0:
			rainfall += 1.0

func set_mountain_rainfall():
	var higher_neighbours = 0
	for node in neighbours:
		if node.elevation > elevation+0.5:
			rainfall += 1

func set_wind_rain(min_value,max_value):
	if rainfall > min_value and rainfall < max_value:
		var wind_node = neighbours[neighbours_directions.find(wind_direction)]
		wind_node.rainfall += rainfall/2
	
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
			
func set_basic_temperature():
	var world_height = get_parent().height
	var slice = world_height/14
	if (Y > slice and Y <= slice*2) or (Y > world_height - (slice*2) and Y <= world_height - slice):
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
	elif (Y > slice*7 and Y <= slice*9):
		temperature = 6.0
	elevation_temperature_adjustment()

func elevation_temperature_adjustment():
	if ground_level > 2:
		temperature -= ground_level/2

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
	color_mode("continent")

func color_mode(mode):
	match mode:
		"continent":
			match continent:
				0: set_self_modulate(Color(0.94,0.1,1,1))
				1: set_self_modulate(Color(0,1,1,1))
				2: set_self_modulate(Color(0.65,0.16,0.16,1))
				3: set_self_modulate(Color(0.86,0.08,0.24,1))
				4: set_self_modulate(Color(0.55,0,0,1))
				5: set_self_modulate(Color(1,0.84,0,1))
				6: set_self_modulate(Color(1,1,0.94,1))
				7: set_self_modulate(Color(1,0.1,0.94,1))
				8: set_self_modulate(Color(0,0,1.94,1))
				9: set_self_modulate(Color(0,1,1.94,1))
				10: set_self_modulate(Color(0,1,0.94,1))
				11: set_self_modulate(Color(0.25,1,1.94,1))
				12: set_self_modulate(Color(0,1,0.25,1))
		"continentconflict":
			if conflictzone: set_self_modulate(Color(1,0.1,0.1,1))
			else: set_self_modulate(Color(0.1,0.1,0.1,1))
		"elevation":
			match round(elevation):
				0.0: set_self_modulate(Color("005a32"))
				1.0: set_self_modulate(Color("238443"))
				2.0: set_self_modulate(Color("41ab5d"))
				3.0: set_self_modulate(Color("78c679"))
				4.0: set_self_modulate(Color("addd8e"))
				5.0: set_self_modulate(Color("d9f0a3"))
				6.0: set_self_modulate(Color("f7fcb9"))
				7.0: set_self_modulate(Color("ffffe5"))
				8.0: set_self_modulate(Color("fff7bc"))
				9.0: set_self_modulate(Color("fee391"))
				10.0: set_self_modulate(Color("fec44f"))
				11.0: set_self_modulate(Color("fe9929"))
				12.0: set_self_modulate(Color("ec7014"))
				13.0: set_self_modulate(Color("cc4c02"))		
				14.0: set_self_modulate(Color("993404"))
				15.0: set_self_modulate(Color("662506"))
				16.0: set_self_modulate(Color("fff7fb"))		
		"rainfall":
			if ground_level < 0:
				return
			match round(rainfall):
				0.0: set_self_modulate(Color("543005"))
				1.0: set_self_modulate(Color("8c510a"))
				2.0: set_self_modulate(Color("bf812d"))
				3.0: set_self_modulate(Color("dfc27d"))
				4.0: set_self_modulate(Color("f6e8c3"))
				5.0: set_self_modulate(Color("f5f5f5"))
				6.0: set_self_modulate(Color("c7eae5"))
				7.0: set_self_modulate(Color("80cdc1"))
				8.0: set_self_modulate(Color("35978f"))
				9.0: set_self_modulate(Color("01665e"))
				10.0: set_self_modulate(Color("003c30"))
		"sea":
			set_ground_level()
			if ground_level >= 0:
				if ground_level < 3:
					if ground_level < 0.2: set_self_modulate(Color("005a32"))
					elif ground_level < 0.4: set_self_modulate(Color("238443"))
					elif ground_level < 0.6: set_self_modulate(Color("41ab5d"))
					elif ground_level < 1.0: set_self_modulate(Color("78c679"))
					elif ground_level < 1.5: set_self_modulate(Color("addd8e"))
					elif ground_level < 2.2: set_self_modulate(Color("d9f0a3"))
					else: set_self_modulate(Color("f7fcb9"))
				else:
					if ground_level > 12.0: set_self_modulate(Color("fff7fb"))
					match round(ground_level): 
						3.0: set_self_modulate(Color("ffffe5"))
						4.0: set_self_modulate(Color("fff7bc"))
						5.0: set_self_modulate(Color("fee391"))
						6.0: set_self_modulate(Color("fec44f"))
						7.0: set_self_modulate(Color("fe9929"))
						8.0: set_self_modulate(Color("ec7014"))
						9.0: set_self_modulate(Color("cc4c02"))		
						10.0: set_self_modulate(Color("993404"))
						11.0: set_self_modulate(Color("662506"))
						12.0: set_self_modulate(Color("fff7fb"))		
			elif ground_level >= -1: set_self_modulate(Color("6baed6"))
			elif ground_level >= -2: set_self_modulate(Color("3182bd"))
			else: set_self_modulate(Color("08519c"))
		"temperature":
			if ground_level < 0: return
			if temperature <= 0.0: set_self_modulate(Color("4575b4"))
			match round(temperature):
				1.0: set_self_modulate(Color("91bfdb"))
				2.0: set_self_modulate(Color("e0f3f8"))
				3.0: set_self_modulate(Color("ffffbf"))
				4.0: set_self_modulate(Color("fee090"))
				5.0: set_self_modulate(Color("fc8d59"))
				6.0: set_self_modulate(Color("d73027"))

func _on_node_action(action,data):
	match action:
		"find_neighbours": find_neighbours()
		"change_color_mode": color_mode(data)
		"set_basic_temperature": set_basic_temperature()
		"set_conflictzone": set_conflictzone()
		"set_mountain_rainfall": set_mountain_rainfall()
		"set_sea_rainfall": set_sea_rainfall()
		"set_wind_rainfall": set_wind_rain(data[0],data[1])
		"set_winds": set_wind()
		"water_erosion": water_erosion()
		"erosion": erosion()
		"smooth_elevation_differences": smooth_elevation_differences(data[0],data[1])
		"show_wind": $wind_arrow.visible = !$wind_arrow.visible
