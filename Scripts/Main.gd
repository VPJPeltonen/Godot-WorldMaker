extends Node2D

func get_node_elevation(X,Y):
	return $Map.get_node_elevation(X,Y)

func get_continent_amount():
	return $UI_container/continents_box.value

func get_sea_level():
	return $UI_container/sea_level_box.value

func get_map_width():
	return $Map.width

func get_map_height():
	return $Map.height
