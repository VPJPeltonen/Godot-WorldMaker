extends Node2D
signal back

func _ready():
	pass # Replace with function body.



func _on_Backbutton_pressed():
	emit_signal("back")


func _on_generateButton_pressed():
	get_node("flag").generate_flag()
	get_node("flag").show()
