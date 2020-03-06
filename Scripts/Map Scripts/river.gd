extends Node2D

var id_number
var river_name = "default river"
var river_nodes = []

func init(new_id,new_source,new_pos):
	id_number = new_id
	river_nodes.append(new_source)
	global_position = new_pos
	find_sea()
	hide()

func find_sea():
	while true:
		var next_node = null
		var river_found = false
		for node in river_nodes[-1].neighbours:
			if node.elevation < river_nodes[-1].elevation and !river_found:
				if node.river != "none":
					next_node = node
					river_found = true
				else:
					if next_node != null:
						if next_node.elevation > node.elevation:
							next_node = node
					else:	
						next_node = node
		if next_node != null:
			river_nodes.append(next_node)
		#if cant find lower ground or finds sea or joins with existing river, the river is done
		if next_node == null or next_node.ground_level <= 0 or next_node.river != "none": 
			return
		else:
			next_node.river = river_name

func show_rivers():
	if visible:
		hide()
	else:
		show()
		#if $river_line.points.size() != 0:
		for node in river_nodes:
			$river_line.add_point(node.position)

func _on_show_river():
	show_rivers()
