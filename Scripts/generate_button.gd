extends Button

func _on_Map_map_generated():
	text = "Clear"
	rect_position = Vector2(1154,16)
	disabled = false

func _on_generate_button_pressed():
	disabled = true
