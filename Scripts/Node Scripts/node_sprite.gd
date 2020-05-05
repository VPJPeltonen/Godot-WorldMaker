extends Sprite

func color_mode(mode,value):
	match mode:
		"blank":
			var color
			if value >= 0:
				color = Color(json_reader.get_color("blank","Land"))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
		"civilization":
			while value >= 16:
				value -= 16
			var color = Color(json_reader.get_color("continent",str(value)))
			set_self_modulate(color)
		"continent":
			var color = Color(json_reader.get_color(mode,str(value)))
			set_self_modulate(color)
		"continentconflict":
			var color = Color(json_reader.get_color(mode,str(value)))
			set_self_modulate(color)
		"elevation":
			var rounded = int(round(value))
			if rounded > 16: rounded = 16
			if rounded < 0: rounded = 0
			var color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"rainfall":
			if get_parent().ground_level < 0:
				return
			var rounded = int(round(value))
			if rounded > 10: rounded = 10
			var color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"sea":
			if value >= 0:
				var rounded
				if value < 3: rounded = stepify(value,0.5)
				else: rounded = int(round(value))
				if rounded > 12: rounded = 12
				var color = Color(json_reader.get_color(mode,str(rounded)))
				set_self_modulate(color)
			else:
				var color
				if value >= -1: color = Color(json_reader.get_color(mode,"-1"))
				elif value >= -2: color = Color(json_reader.get_color(mode,"-2"))
				else: color = Color(json_reader.get_color(mode,"-3"))
				set_self_modulate(color)
		"temperature":
			if get_parent().ground_level < 0: return
			var rounded = int(round(value))
			if rounded < 0: rounded = 0
			var color = Color(json_reader.get_color(mode,str(rounded)))
			set_self_modulate(color)
		"climate":
			var color = Color(json_reader.get_color(mode,value))
			set_self_modulate(color)
		"satellite":
			var color = Color(json_reader.get_color(mode,value))
			set_self_modulate(color)
		"rivers":
			var color
			if value >= 0:
				color = Color(json_reader.get_color("blank","Land"))
			else:
				color = Color(json_reader.get_color("blank","Sea"))
			set_self_modulate(color)
