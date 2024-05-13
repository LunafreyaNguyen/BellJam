extends Node


@export var scrollSpeed = -0.1

func _ready():
	self.material.set_shader_parameter("scrollSpeed", scrollSpeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
