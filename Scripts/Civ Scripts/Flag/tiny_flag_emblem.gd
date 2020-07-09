extends Sprite

export(Texture) var bird_sprite
export(Texture) var crown_sprite
export(Texture) var moon_sprite
export(Texture) var shield_sprite
export(Texture) var starfive_sprite
export(Texture) var starsix_sprite
export(Texture) var sun_sprite
export(Texture) var sword_sprite
export(Texture) var tower_sprite
export(Texture) var x_sprite

func set_emblem(emblem, emblem_color, pattern_type):
	
	match pattern_type:
		"canton":
			$tiny_emblem2.hide()
			position = Vector2(-6,-4)
		"chevron":
			$tiny_emblem2.hide()
			position = Vector2(-8,0)
		"quadricsection":
			position = Vector2(-6,-4)
			$tiny_emblem2.show()
			$tiny_emblem2.set_emblem(emblem, emblem_color, "quadricsection 2")
		"reverse quadrisection":
			position = Vector2(6,-4)
			$tiny_emblem2.show()
			$tiny_emblem2.set_emblem(emblem, emblem_color, "reverse quadrisection 2")
		"quadricsection 2":
			position = Vector2(12,8)
		"reverse quadrisection 2":
			position = Vector2(-12,8)
	match emblem:
		"bird":
			set_texture(bird_sprite)
		"crown":
			set_texture(crown_sprite)
		"moon":
			set_texture(moon_sprite)
		"shield":
			set_texture(shield_sprite)
		"star 5":
			set_texture(starfive_sprite)
		"star 6":
			set_texture(starsix_sprite)
		"sun":
			set_texture(sun_sprite)
		"sword":
			set_texture(sword_sprite)
		"tower":
			set_texture(tower_sprite)
		"x":
			set_texture(x_sprite)
	set_modulate(emblem_color)
