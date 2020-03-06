extends Node

var id_number
var river_name = "default river"
var river_nodes = []

func init(new_id,new_source):
	id_number = new_id
	river_nodes.append(new_source)
	find_sea()

func find_sea():
	while true:
		var next_node = null
		for node in river_nodes[-1].neighbours:
			if node.elevation < river_nodes[-1].elevation:
				if next_node != null:
					if next_node.elevation > node.elevation:
						next_node = node
				else:	
					next_node = node
		#if cant find lower ground or finds sea or joins with existing river, the river is done
		if next_node == null or next_node.ground_level <= 0 or next_node.river != "none": 
			return
		else:
			river_nodes.append(next_node)
			next_node.river = river_name
