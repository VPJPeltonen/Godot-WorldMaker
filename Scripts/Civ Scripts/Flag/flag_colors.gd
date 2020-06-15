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

var colors_array = [
	Color("#000000"),  #black
	Color("#00993e"),  #green
	Color("#078930"),  #green
	Color("#c8312a"),  #red
	Color("#d32011"),  #red
	Color("#da201f"),  #red
	Color("#25369d"),  #blue
	Color("#4590cb"),  #blue
	Color("#0f204b"),  #blue
	Color("#f6d323"),  #yellow
	Color("#ffb612"),  #yellow
	Color("#ff883e"),  #orange
	Color("#ffffff")   #white
]

func get_colors():
	var colors = [colors_array[rng.randi_range(0,colors_array.size()-1)]]
	
	while(true):
		var new_color = colors_array[rng.randi_range(0,colors_array.size()-1)]
		if new_color != colors_array[0]:
			colors.append(new_color)
			break;
	while(true):
		var new_color = colors_array[rng.randi_range(0,colors_array.size()-1)]
		if new_color != colors_array[0] and new_color != colors_array[1]:
			colors.append(new_color)
			break;
	while(true):
		var new_color = colors_array[rng.randi_range(0,colors_array.size()-1)]
		if new_color != colors_array[0] and new_color != colors_array[1] and new_color != colors_array[2]:
			colors.append(new_color)
			break;
	return colors
