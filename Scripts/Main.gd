extends Node2D

#
# This mostly passes info and methods between nodes
#
func get_civ_amount():
	return $UI/UI_container/civ_settings/civ_amount_box.value
	
func get_node_info(X,Y):
	return $Map.get_node_info(X,Y)
	
func get_civ_info(X,Y):
	return $Map.get_civ_info(X,Y)

func get_continent_amount():
	return $UI/generation_UI/continents_box.value

func get_sea_level():
	return $UI/UI_container/adjustments/sea_level_box.value

func get_map_width():
	return $Map.width

func get_map_height():
	return $Map.height

func get_map_size():
	return Vector2($Map.width,$Map.height)

func get_node_scale():
	return $Map.node_scale

func color_nodes(mode):
	$Map.color_nodes(mode)
	$Map/guide.view(mode)

func toggle_rivers(toggle):
	$Map.emit_signal("show_river", toggle)

func toggle_shadows(on):
	$Map.toggle_shadows(on)

func lock_camera():
	$Camera2D.locked = true

func unlock_camera():
	$Camera2D.locked = false

func hide_UI():
	$UI/UI_container.hide()
	$UI/saveUI.hide()
	$UI/Node_info.hide()
	$UI/civ_info.hide()
	$UI/help_controller.hide()
	$UI/generate_button.hide()
	
func show_UI():
	$UI/UI_container.show()
	$UI/saveUI.show()
	$UI/Node_info.show()
	$UI/civ_info.show()
	$UI/help_controller.show()
	$UI/generate_button.show()
	
func disable_buttons():
	$UI/UI_container/adjustments/smooth_button.disabled = true
	$UI/UI_container/adjustments/smooth_ele_button.disabled = true
	$UI/UI_container/adjustments/water_erosion_button.disabled = true
	$UI/UI_container/adjustments/apply_settings_button.disabled = true

func enable_buttons():
	$UI/UI_container/adjustments/smooth_button.disabled = false
	$UI/UI_container/adjustments/smooth_ele_button.disabled = false
	$UI/UI_container/adjustments/water_erosion_button.disabled = false
	$UI/UI_container/adjustments/apply_settings_button.disabled = false

func move_to_export_pos():
	$Camera2D.move_to_export_pos($Map.position)

func set_info_label(info):
	$UI/info_label.text = info

func view_mode():
	$UI/generation_UI.hide()
