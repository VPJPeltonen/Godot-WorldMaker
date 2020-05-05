extends Node2D

var civ_name = "Generic Civ"
var capital
var area = []
var civ_color

func init_civ(node,num):
	capital = node
	civ_color = num
	capital.owning_civ = self
