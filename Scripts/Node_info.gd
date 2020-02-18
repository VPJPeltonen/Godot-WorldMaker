extends VBoxContainer

func _on_cursor_node_info(elevation, X, Y):
	$nodeheight/height_number.text = str(elevation)
	$nodeX/x_number.text = str(X)
	$nodeY/y_number.text = str(Y)
