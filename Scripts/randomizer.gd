extends Node

var rng = RandomNumberGenerator.new()

var seed_string

func _ready():
	pass
	#rng.set_seed(123)

func set_seed(new_seed):
	new_seed = str(new_seed)
	if new_seed == null or new_seed == "":
		rng.randomize()
		var chars = json_reader.get_chars()
		var seed_length = rng.randi_range(4,8)
		new_seed = ""
		for i in range(seed_length):
			new_seed += chars[str(rng.randi_range(0,chars.size()-1))]
	seed_string = new_seed
	rng.set_seed(new_seed.hash())
