extends Sprite

func color_mode(mode,value):
	var color
	match mode:
		"blank":
			if value >= 0:
				color = Color(json_reader.get_color("blank","Land"))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
		"civilization":
			while value >= 16:
				value -= 16
			color = Color(json_reader.get_color("continent",str(value)))
			set_self_modulate(color)
		"continent":
			color = Color(json_reader.get_color(mode,str(value)))
			set_self_modulate(color)
		"continentconflict":
			color = Color(json_reader.get_color(mode,str(value)))
			set_self_modulate(color)
		"elevation":
			var rounded = int(round(value))
			if rounded > 16: rounded = 16
			if rounded < 0: rounded = 0
			color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"rainfall":
			if get_parent().ground_level < 0:
				return
			var rounded = int(round(value))
			if rounded > 10: rounded = 10
			color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"sea":
			if value >= 0:
				var rounded
				if value < 3: rounded = stepify(value,0.5)
				else: rounded = int(round(value))
				if rounded > 12: rounded = 12
				color = Color(json_reader.get_color(mode,str(rounded)))
				set_self_modulate(color)
			else:
				color
				if value >= -1: color = Color(json_reader.get_color(mode,"-1"))
				elif value >= -2: color = Color(json_reader.get_color(mode,"-2"))
				else: color = Color(json_reader.get_color(mode,"-3"))
				set_self_modulate(color)
		"temperature":
			if get_parent().ground_level < 0: return
			var rounded = int(round(value))
			if rounded < 0: rounded = 0
			color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"climate":
			color = Color(json_reader.get_color(mode,value))
			set_self_modulate(color)
		"satellite":
			color = Color(json_reader.get_color(mode,value))
			set_self_modulate(color)
		"rivers":
			if value >= 0:
				color = Color(json_reader.get_color("blank","Land"))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
	for node in get_children():
		node.color_mode(mode)
