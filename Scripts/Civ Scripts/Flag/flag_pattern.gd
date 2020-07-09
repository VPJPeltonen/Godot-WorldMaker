extends Sprite

export(Texture) var border_sprite
export(Texture) var canton_sprite
export(Texture) var fimbriation_sprite
export(Texture) var hoist_sprite
export(Texture) var quadrisection_sprite
export(Texture) var reverse_quadrisection_sprite
export(Texture) var pale_sprite
export(Texture) var fess_sprite
export(Texture) var bend_sprite
export(Texture) var chevron_sprite
export(Texture) var pall_sprite
export(Texture) var saltire_sprite

func set_pattern(var pattern, var pattern_color):
	match pattern:
		"border":
			set_texture(border_sprite)
		"hoist":
			set_texture(hoist_sprite)
		"fimbriation":
			set_texture(fimbriation_sprite)
		"canton":
			set_texture(canton_sprite)
		"quadrisection":
			set_texture(quadrisection_sprite)
		"reverse quadrisection":
			set_texture(reverse_quadrisection_sprite)
		"hoist":
			set_texture(hoist_sprite)
		"pale":
			set_texture(pale_sprite)
		"fess":
			set_texture(fess_sprite)
		"bend":
			set_texture(bend_sprite)
		"chevron":
			set_texture(chevron_sprite)
		"pall":
			set_texture(pall_sprite)
		"saltire":
			set_texture(saltire_sprite)
	set_modulate(pattern_color)
