extends Label


func _on_help_controller_pressed():
	if visible: hide()
	else: show()
