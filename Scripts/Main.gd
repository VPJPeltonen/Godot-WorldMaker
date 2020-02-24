extends Node2D

func get_node_info(X,Y):
	return $Map.get_node_info(X,Y)

func get_continent_amount():
	return $UI/UI_container/generation_UI/continents_box.value

func get_sea_level():
	return $UI/UI_container/map_settings/sea_level_box.value

func get_map_width():
	return $Map.width

func get_map_height():
	return $Map.height

func get_map_size():
	return Vector2($Map.width,$Map.height)

func get_node_scale():
	return $Map.node_scale

func hide_UI():
	$UI/UI_container.hide()
	$UI/saveUI.hide()
	$UI/Node_info.hide()
	
func show_UI():
	$UI/UI_container.show()
	$UI/saveUI.show()
	$UI/Node_info.show()
		
func move_to_export_pos():
	$Camera2D.move_to_export_pos($Map.position)
	#$Map_camera.position = Vector2($Map.position.x,$Map.position.y)
	#$Map_camera.make_current()

func view_mode():
	$UI/UI_container/generation_UI.hide()
