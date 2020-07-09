extends Node2D

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

var has_special_emblem = [
	"canton",
	"quadrisection",
	"reverse quadrisection",
	"chevron"
]

#saved flag info
var background_color
var pattern_type
var pattern_color
var pattern2_type
var pattern2_color
var emblem_type
var emblem_color

func _ready():
	generate_flag()

func get_flag_info():
	var info = {
		"background color" : background_color,
		"pattern type" : pattern_type,
		"pattern color" : pattern_color,
		"pattern 2 type" : pattern2_type,
		"pattern 2 color" : pattern2_color,
		"emblem type" : emblem_type,
		"emblem color" : emblem_color
	}
	return info

func set_flag(new_info):
	if typeof(new_info) == TYPE_DICTIONARY:
		background_color = new_info["background color"]
		pattern_type	 = new_info["pattern type"]
		pattern_color	 = new_info["pattern color"]
		pattern2_type	 = new_info["pattern 2 type"]
		pattern2_color	 = new_info["pattern 2 color"]
		emblem_type		 = new_info["emblem type"]
		emblem_color	 = new_info["emblem color"]
		show_flag()
	else:
		pass

func generate_flag():
	rng.randomize()
	var colors = get_node("colors").get_colors()
	background_color = colors[0]
	pattern_type     = patterns[rng.randi_range(0,patterns.size()-1)]
	pattern_color    = colors[1]
	var has_second_pattern = rng.randi_range(0,1)
	if(has_second_pattern == 1):
		pattern2_type = patterns[rng.randi_range(0,patterns.size()-1)]
	else: 
		pattern2_type    = "none"
	pattern2_color = colors[2]
	var has_emblem = rng.randi_range(0,1)
	if(has_emblem == 1):
		if has_special_emblem.has(pattern_type):
			pass
		else:
			emblem_type = badges[rng.randi_range(0,badges.size()-1)]
	else:
		emblem_type      = "none"
	emblem_color = colors[3]
	show_flag()
	self.hide()

func show_flag():
	get_node("background").set_modulate(background_color)
	get_node("pattern").set_pattern(pattern_type,pattern_color)
	if(pattern2_type != "none"):
		get_node("pattern2").show()
		get_node("pattern2").set_pattern(pattern2_type,pattern2_color)
	else:
		get_node("pattern2").hide()
	if(emblem_type != "none"):
		if has_special_emblem.has(pattern_type):
			get_node("emblem").hide()
			get_node("tiny_emblem1").show()
			get_node("tiny_emblem1").set_emblem(emblem_type,emblem_color,pattern_type)
		else:
			get_node("tiny_emblem1").hide()
			get_node("emblem").show()
			get_node("emblem").set_emblem(emblem_type,emblem_color)
	else:
		get_node("emblem").hide()
		get_node("tiny_emblem1").hide()
