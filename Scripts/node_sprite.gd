extends Sprite

func color_mode(mode,value):
	match mode:
		"continent":
			match value:
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
			if value: set_self_modulate(Color(1,0.1,0.1,1))
			else: set_self_modulate(Color(0.1,0.1,0.1,1))
		"elevation":
			match round(value):
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
			if get_parent().ground_level < 0:
				return
			match round(value):
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
			#set_ground_level()
			if value >= 0:
				if value < 3:
					if value < 0.2: set_self_modulate(Color("005a32"))
					elif value < 0.4: set_self_modulate(Color("238443"))
					elif value < 0.6: set_self_modulate(Color("41ab5d"))
					elif value < 1.0: set_self_modulate(Color("78c679"))
					elif value < 1.5: set_self_modulate(Color("addd8e"))
					elif value < 2.2: set_self_modulate(Color("d9f0a3"))
					else: set_self_modulate(Color("f7fcb9"))
				else:
					if value > 12.0: set_self_modulate(Color("fff7fb"))
					match round(value): 
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
			elif value >= -1: set_self_modulate(Color("6baed6"))
			elif value >= -2: set_self_modulate(Color("3182bd"))
			else: set_self_modulate(Color("08519c"))
		"temperature":
			if get_parent().ground_level < 0: return
			if value <= 0.0: set_self_modulate(Color("4575b4"))
			match round(value):
				1.0: set_self_modulate(Color("91bfdb"))
				2.0: set_self_modulate(Color("e0f3f8"))
				3.0: set_self_modulate(Color("ffffbf"))
				4.0: set_self_modulate(Color("fee090"))
				5.0: set_self_modulate(Color("fc8d59"))
				6.0: set_self_modulate(Color("d73027"))
		"climate":
			#if get_parent().ground_level < 0: return
			match value:
				"Sea": return
				"Polar Desert": set_self_modulate(Color("5a5a5a"))
				"Ice Cap": set_self_modulate(Color("ffffff"))
				"Tundra": set_self_modulate(Color("bfbfbf"))
				"Wet Tundra": set_self_modulate(Color("ccc0da"))
				"Polar Wetlands": set_self_modulate(Color("60497b"))
				"Cool Desert": set_self_modulate(Color("953735"))
				"Steppe": set_self_modulate(Color("948b54"))
				"Temperate Woodlands": set_self_modulate(Color("f2dddc"))
				"Temperate Forest": set_self_modulate(Color("dbeef3"))
				"Temperate Wet Forest": set_self_modulate(Color("93cddd"))
				"Temperate Wetlands": set_self_modulate(Color("31849b"))
				"Extreme Desert": set_self_modulate(Color("ff5050"))
				"Desert": set_self_modulate(Color("ff9900"))
				"Subtropical Scrup": set_self_modulate(Color("cccc00"))
				"Subtropical Woodlands": set_self_modulate(Color("fcd5b4"))
				"Mediterranean": set_self_modulate(Color("d99795"))
				"Subtropical Dry Forest": set_self_modulate(Color("d7e4bc"))
				"Subtropical Forest": set_self_modulate(Color("66ff66"))
				"Subtropical Wet Forest": set_self_modulate(Color("00b050"))
				"Subtropical Wetlands": set_self_modulate(Color("00823b"))
				"Tropical Scrup": set_self_modulate(Color("ffff00"))
				"Tropical Woodlands": set_self_modulate(Color("fffbc1"))
				"Tropical Dry Forest": set_self_modulate(Color("ccff33"))
				"Tropical Wet Forest": set_self_modulate(Color("75923c"))
				"Tropical Wetlands": set_self_modulate(Color("4f6228"))
