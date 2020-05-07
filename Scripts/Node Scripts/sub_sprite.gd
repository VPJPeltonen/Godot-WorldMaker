extends Sprite

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

var continent
var conflictzone

var main_node

func color_sub_sprite(color):
	set_self_modulate(color)

func init_sub_sprite(creator):
	main_node = creator
	set_values()

func set_values():
	arability 		= main_node.arability
	rainfall 		= max(main_node.rainfall		+ randomizer.rng.randf_range(-1,1),0)
	wind_direction 	= main_node.wind_direction
	temperature 	= min(main_node.temperature 	+ randomizer.rng.randf_range(-1,1),6)
	elevation 		= max(main_node.elevation		+ randomizer.rng.randf_range(-0.1,0.1),0)
	sea_level 		= main_node.sea_level
	ground_level 	= elevation-sea_level
	climate 		= main_node.climate
	river 			= main_node.river
	lake 			= main_node.lake
	owning_civ 		= main_node.owning_civ
	continent 		= main_node.continent
	conflictzone 	= main_node.conflictzone
	set_climate()
	color_mode("satellite")
	
func set_climate():
	if ground_level < 0:
		if temperature <= 0.1 and rainfall >= 3:
			climate = "Ice Cap"
		else:
			if ground_level >= -1: climate = "Coastal Sea"
			elif ground_level >= -2: climate = "Sea"
			else: climate = "Deep Sea"
	else:
		if lake:
			climate = "Lake"
		elif temperature <= 0.1:
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

func color_mode(mode):
	var color
	match mode:
		"blank":
			if ground_level >= 0:
				color = Color(json_reader.get_color("blank","Land"))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
		"civilization":
			if ground_level >= 0:
				var value = owning_civ.civ_color
				while value >= 16:
					value -= 16
				color = Color(json_reader.get_color("continent",str(value)))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
		"continent":
			color = Color(json_reader.get_color(mode,str(continent)))
			set_self_modulate(color)
		"continentconflict":
			color = Color(json_reader.get_color(mode,str(conflictzone)))
			set_self_modulate(color)
		"elevation":
			var rounded = int(round(elevation))
			if rounded > 16: rounded = 16
			if rounded < 0: rounded = 0
			color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"rainfall":
			if ground_level < 0:
				return
			var rounded = int(round(rainfall))
			if rounded > 10: rounded = 10
			color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"sea":
			if ground_level >= 0:
				var rounded
				if ground_level < 3: rounded = stepify(ground_level,0.5)
				else: rounded = int(round(ground_level))
				if rounded > 12: rounded = 12
				color = Color(json_reader.get_color(mode,str(rounded)))
				set_self_modulate(color)
			else:
				color
				if ground_level >= -1: color = Color(json_reader.get_color(mode,"-1"))
				elif ground_level >= -2: color = Color(json_reader.get_color(mode,"-2"))
				else: color = Color(json_reader.get_color(mode,"-3"))
				set_self_modulate(color)
		"temperature":
			if ground_level < 0: 
				color = Color(json_reader.get_color("blank","Sea"))
			else:
				var rounded = int(round(temperature))
				if rounded < 0: rounded = 0
				color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"climate":
			color = Color(json_reader.get_color(mode,climate))
			set_self_modulate(color)
		"satellite":
			color = Color(json_reader.get_color(mode,climate))
			set_self_modulate(color)
		"rivers":
			if ground_level >= 0:
				color = Color(json_reader.get_color("blank","Land"))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
