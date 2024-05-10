extends Node2D
@onready var Camera = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.get_action_raw_strength("shoot"):
		pass
		#Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
