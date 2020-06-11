extends Node

#basic color of flag
var base_color
var rng = RandomNumberGenerator.new()

#pattern the flag has
var patterns = [
	"border",
	"canton",
	"quadrisection",
	"reverse quadrisection",
	"pale",
	"fess",
	"bend",
	"chevron",
	"pall",
	"saltire"
]

#color the pattern has
var pattern_color 

#bool to see if flag has badge
var badge

var badges = [
	"bird",
	"moon",
	"shield",
	"star",
	"sun",
	"sword",
	"tower",
	"x"
]

func _ready():
	generate_flag()

func generate_flag():
	var colors = get_node("colors").get_colors()
	get_node("background").set_modulate(colors[0])
	get_node("pattern").set_pattern(patterns[rng.randi_range(0,patterns.size()-1)],colors[1])
