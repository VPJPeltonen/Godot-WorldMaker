extends Node2D

func get_node_info(X,Y):
	return $Map.get_node_info(X,Y)

func get_continent_amount():
	return $Camera2D/UI_container/generation_UI/continents_box.value

func get_sea_level():
	return $Camera2D/UI_container/map_settings/sea_level_box.value

func get_map_width():
	return $Map.width

func get_map_height():
	return $Map.height

func get_node_scale():
	return $Map.node_scale

func view_mode():
	$Camera2D/UI_container/generation_UI.hide()
