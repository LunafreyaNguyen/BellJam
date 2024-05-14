extends CharacterBody2D

@export var Bullet: PackedScene
@onready var bulletSpawnM = $bulletSpawn1
@onready var bulletSpawnL = $bulletSpawn2
@onready var bulletSpawnR = $bulletSpawn3
@onready var sprite = $Sprite2D
@onready var hit_box = $CollisionShape2D/HitBox
@onready var focus_bar = $"Focus Bar"

const styleS = preload("res://Art/style/S.png")
const styleA = preload("res://Art/style/A.png")
const styleB = preload("res://Art/style/B.png")
const styleC = preload("res://Art/style/C.png")
const styleD = preload("res://Art/style/D.png")

@onready var styles = [styleD, styleC, styleB, styleA, styleS]
@onready var currStyle = 2
@onready var styleProgress = 0

@onready var Camera = get_tree().get_first_node_in_group("Camera")
@onready var style = get_tree().get_first_node_in_group("style")

@export var gameOver = preload("res://Scenes/gameover.tscn") as PackedScene

@export var start_level = preload("res://Scenes/levels/testLuna.tscn") as PackedScene
@onready var parry_timer = $ParryTimer
@onready var collision_shape_2d = $CollisionShape2D

# Character's stats
@export_group("Stats")
@export var speed = 450.0
@export var fireRate = .1
var dead: bool = false
var timer = 0
@export var invulnerable = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = input_direction * speed
	sprite.modulate.a = 1.0
	hit_box.visible = false
	if Input.get_action_raw_strength("parry"):
		parry_timer.start()
	if Input.get_action_raw_strength("focus") && focus_bar.get_burnout_condition() == false:
		velocity = velocity * .5
		focus_bar.add_value(15)
		hit_box.visible = true
		sprite.modulate.a = .4
	elif(focus_bar.get_burnout_condition() == false):
		focus_bar.decrease_value(20)
		hit_box.visible = false
	if(input_direction.x > 0):
		sprite.set_rotation(.3)
	elif(input_direction.x < 0):
		sprite.set_rotation(-.3)
	else:
		sprite.set_rotation(0)

func parry():
	invulnerable = true
	#Somehow delete bullet that enters player collisionbox

func _on_parry_timer_timeout():
	invulnerable = false
	parry_timer.stop()


func hit():
	if !invulnerable:
		if currStyle == 0:
			for s in get_tree().get_nodes_in_group("EnemyBullet"):
				s.queue_free()
			get_tree().change_scene_to_packed(gameOver)
			styleProgress = 0
		else:
			if currStyle >= 2:
				currStyle -= 2
			else:
				currStyle = 0
			styleProgress = 0
			Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
			invulnerable = true
			for nodes in get_tree().get_nodes_in_group("EnemyBullet"):
				nodes.queue_free()
			var playerPortrait = get_tree().get_first_node_in_group("PlayerPortrait")
			playerPortrait.visible = not playerPortrait.visible
			for x in 8:
				Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
				sprite.visible = not sprite.visible
				await get_tree().create_timer(.1).timeout
			playerPortrait.visible = not playerPortrait.visible
			Camera.set("offset", Vector2(0, 0))
			invulnerable = false

func isInvulnerable():
	return invulnerable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if styleProgress > 100:
		if currStyle < 4:
			currStyle += 1
			styleProgress = 0
		else:
			styleProgress = 0
	style.set_texture(styles[currStyle])
	timer += delta
	get_input()
	move_and_slide()
	if parry_timer.time_left > 0:
		parry()
	if timer > fireRate:
		if Input.get_action_raw_strength("shoot"):
			var temp1 = Bullet.instantiate()
			var temp2 = Bullet.instantiate()
			var temp3 = Bullet.instantiate()
			add_sibling(temp1)
			add_sibling(temp2)
			add_sibling(temp3)
			if Input.get_action_raw_strength("focus") && focus_bar.get_burnout_condition() == false:
				bulletSpawnL.position.x = -40
				bulletSpawnR.position.x = 40
			else:
				bulletSpawnL.position.x = 100
				bulletSpawnR.position.x = -100
			temp1.global_position = bulletSpawnM.get("global_position")
			temp2.global_position = bulletSpawnL.get("global_position")
			temp3.global_position = bulletSpawnR.get("global_position")
			timer = 0
