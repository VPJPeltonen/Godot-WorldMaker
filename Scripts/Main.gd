extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_continent_amount():
	return $UI_container/continents_box.value

func get_sea_level():
	return $UI_container/sea_level_box.value
