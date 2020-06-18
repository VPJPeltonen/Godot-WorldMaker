extends Node2D

signal back

var flag_name

func get_flag():
	return get_node("flag")

func generate_name():
	var civ_name = ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var names = json_reader.get_civ_names()
	var type_chance = rng.randi_range(0,3)
	var governments = names["governments"]
	if(type_chance == 1):
		governments = governments["rare"]
	else:
		governments = governments["common"]
	civ_name += governments[str(rng.randi_range(0,governments.size()-1))] + " of "
	var first_part = names["part one"]
	var second_part = names["part two"]
	civ_name += first_part[str(rng.randi_range(0,first_part.size()-1))] + second_part[str(rng.randi_range(0,second_part.size()-1))]
	flag_name = civ_name
	get_node("civ_name").text = civ_name

func _on_Backbutton_pressed():
	emit_signal("back")

func _on_generateButton_pressed():
	generate_name()
	get_node("flag").generate_flag()
	get_node("flag").show()
