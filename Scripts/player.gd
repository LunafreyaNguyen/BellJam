extends CharacterBody2D

# Character's stats
const speed = 500.0
const fireRate = .2
var dead: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = input_direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	move_and_slide()
