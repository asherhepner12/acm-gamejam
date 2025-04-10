extends Node
class_name LocationNode

var backdrop = null
var left = null
var right = null
var forward = null
var back = null
var npcs = [null,null,null,null,null,null,null,null,null,null] 
var accessible = true
var transition = -1
#func _init():
	#npcs.resize(10)
