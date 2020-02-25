extends Node

var node_colors

func _ready():
	node_colors = read_data("res://Data/node_colors.json") 

func read_data(path):
	var data_file = File.new()
	if data_file.open(path, File.READ) != OK:
		return ""
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return ""
	var data = data_parse.result
	return data

func get_color(mode,value):
	var colors = node_colors[mode]
	var color = colors[value]
	return color

func get_colors(mode):
	var colors = node_colors[mode]
	return colors
