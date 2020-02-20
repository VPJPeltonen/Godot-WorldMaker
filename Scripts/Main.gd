extends Node2D

func get_node_info(X,Y):
	return $Map.get_node_info(X,Y)

func get_continent_amount():
	return $UI_container/generation_UI/continents_box.value

func get_sea_level():
	return $UI_container/map_settings/sea_level_box.value

func get_map_width():
	return $Map.width

func get_map_height():
	return $Map.height
	
func view_mode():
	$UI_container/generation_UI.hide()
