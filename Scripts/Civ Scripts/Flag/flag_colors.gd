extends Node

var rng = RandomNumberGenerator.new() 

var dark_colors = [
	Color("#007514"), #green
	Color("#800505"), #red
	Color("#073e91"), #blue
	Color("#798000"), #yellow
	Color("#000000")  #black
]

var light_colors = [
	Color("#5ce673"), #green
	Color("#db5151"), #red
	Color("#4580d9"), #blue
	Color("#d7de59"), #yellow
	Color("#ffffff")  #black
]

func get_colors():
	var colors = [
		dark_colors[rng.randi_range(0,dark_colors.size()-1)],
		light_colors[rng.randi_range(0,light_colors.size()-1)]
	]
	return colors
