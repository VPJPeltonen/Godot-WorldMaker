extends Node2D

#basic color of flag
var base_color
var rng = RandomNumberGenerator.new()

#pattern the flag has
var patterns = [
	"border",
	"canton",
	"fimbriation",
	"quadrisection",
	"hoist",
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
	"crown",
	"moon",
	"shield",
	"star 5",
	"star 6",
	"sun",
	"sword",
	"tower",
	"x"
]

func _ready():
	generate_flag()

func generate_flag():
	rng.randomize()
	var colors = get_node("colors").get_colors()
	
	get_node("background").set_modulate(colors[0])
	
	get_node("pattern").set_pattern(patterns[rng.randi_range(0,patterns.size()-1)],colors[1])
	
	var has_second_pattern = rng.randi_range(0,1)
	if(has_second_pattern == 1):
		get_node("pattern2").show()
		get_node("pattern2").set_pattern(patterns[rng.randi_range(0,patterns.size()-1)],colors[2])
	else:
		get_node("pattern2").hide()
		
	var has_emblem = rng.randi_range(0,1)
	if(has_emblem == 1):
		get_node("emblem").show()
		get_node("emblem").set_emblem(badges[rng.randi_range(0,badges.size()-1)],colors[3])
	else:
		get_node("emblem").hide()
	self.hide()
