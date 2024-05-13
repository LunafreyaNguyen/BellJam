extends Node

@export var scrollSpeed = -0.1


func _ready():
	self.material.set_shader_parameter("scrollSpeed", scrollSpeed)
