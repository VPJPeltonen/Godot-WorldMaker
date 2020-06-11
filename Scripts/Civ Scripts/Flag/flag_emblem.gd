extends Sprite

export(Texture) var bird_sprite
export(Texture) var moon_sprite
export(Texture) var shield_sprite
export(Texture) var starfive_sprite
export(Texture) var starsix_sprite
export(Texture) var sun_sprite
export(Texture) var sword_sprite
export(Texture) var tower_sprite
export(Texture) var x_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_emblem(var emblem, var emblem_color):
	match emblem:
		"bird":
			set_texture(bird_sprite)
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
