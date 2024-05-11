extends CharacterBody2D

@export var Bullet: PackedScene
@onready var bulletSpawnM = $bulletSpawn1
@onready var bulletSpawnL = $bulletSpawn2
@onready var bulletSpawnR = $bulletSpawn3
@onready var sprite = $Sprite2D

# Character's stats
@export var speed = 700.0
@export var fireRate = .1
var dead: bool = false
var timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = input_direction * speed
	if Input.get_action_raw_strength("focus"):
		velocity = velocity * .5
	if(input_direction.x > 0):
		sprite.set_rotation(.3)
	elif(input_direction.x < 0):
		sprite.set_rotation(-.3)
	else:
		sprite.set_rotation(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timer += delta
	get_input()
	move_and_slide()
	if timer > fireRate:
		if Input.get_action_raw_strength("shoot"):
			print("IM SHOOTING ROPES")
			var temp1 = Bullet.instantiate()
			var temp2 = Bullet.instantiate()
			var temp3 = Bullet.instantiate()
			add_sibling(temp1)
			add_sibling(temp2)
			add_sibling(temp3)
			if Input.get_action_raw_strength("focus"):
				bulletSpawnL.position.x = -40
				bulletSpawnR.position.x = 40
			else:
				bulletSpawnL.position.x = 85
				bulletSpawnR.position.x = -85
			temp1.global_position = bulletSpawnM.get("global_position")
			temp2.global_position = bulletSpawnL.get("global_position")
			temp3.global_position = bulletSpawnR.get("global_position")
			timer = 0
