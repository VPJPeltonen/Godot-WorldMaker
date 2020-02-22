extends Node2D

func get_map_size():
	var map_scale = get_parent().get_node_scale()
	var map_width = get_parent().get_map_width()*map_scale
	var map_height = get_parent().get_map_height()*map_scale
	return Vector2(map_width,map_height)
