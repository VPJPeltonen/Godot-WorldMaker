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
var owning_civ
var continent
var conflictzone = false

var node_color
var offset

func init_new_node(host):
	arability 		= host.arability
	rainfall 		= max(host.rainfall		+ randomizer.rng.randf_range(-1,1),0)
	wind_direction 	= host.wind_direction
	temperature 	= min(host.temperature 	+ randomizer.rng.randf_range(-1,1),6)
	elevation 		= max(host.elevation		+ randomizer.rng.randf_range(-0.1,0.1),0)
	sea_level 		= host.sea_level
	ground_level 	= elevation-sea_level
	climate 		= host.climate
	river 			= host.river
	lake 			= host.lake
	owning_civ 		= host.owning_civ
	continent 		= host.continent
	conflictzone 	= host.conflictzone
	set_climate()
	
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
			return
		var climates = json_reader.get_climates()
		var temp_temp = round(clamp(temperature,0,6))
		var temp_rain = round(clamp(rainfall,1,8))
		climates = climates[ str(int(temp_temp)) ]
		climate = climates[ str(int(temp_rain)) ]

func color_mode(mode):
	match mode:
		"blank":
			if ground_level >= 0:
				node_color = Color(json_reader.get_color("blank","Land"))
			else:
				node_color = Color(json_reader.get_color("blank","Sea"))
		"civilizations":
			if owning_civ == null:
				return
			if ground_level < 0: 
				node_color = Color(json_reader.get_color("blank","Sea"))
			else:
				while owning_civ.civ_color >= 16:
					owning_civ.civ_color -= 16
				node_color = Color(json_reader.get_color("continent",str(owning_civ.civ_color)))
		"continent":
			node_color = Color(json_reader.get_color(mode,str(continent)))
		"continentconflict":
			node_color = Color(json_reader.get_color(mode,str(conflictzone)))
		"elevation":
			var rounded = int(round(elevation))
			if rounded > 16: rounded = 16
			if rounded < 0: rounded = 0
			node_color = Color(json_reader.get_color(mode,str(rounded)))
		"rainfall":
			if ground_level < 0:
				return
			var rounded = int(round(rainfall))
			if rounded > 10: rounded = 10
			node_color = Color(json_reader.get_color(mode,str(rounded)))
		"sea":
			if ground_level >= 0:
				var rounded
				if ground_level < 3: rounded = stepify(ground_level,0.5)
				else: rounded = int(round(ground_level))
				if rounded > 12: rounded = 12
				node_color = Color(json_reader.get_color(mode,str(rounded)))
			else:
				if ground_level >= -1: node_color = Color(json_reader.get_color(mode,"-1"))
				elif ground_level >= -2: node_color = Color(json_reader.get_color(mode,"-2"))
				else: node_color = Color(json_reader.get_color(mode,"-3"))
		"temperature":
			if ground_level < 0: return
			var rounded = int(round(temperature))
			if rounded < 0: rounded = 0
			node_color = Color(json_reader.get_color(mode,str(rounded)))
		"climate":
			node_color = Color(json_reader.get_color(mode,climate))
		"satellite":
			node_color = Color(json_reader.get_color(mode,climate))

func set_offset_value(values):
	offset = values
