extends Area2D
class_name EnemyBullet

@onready var sprite = $Sprite2D

@export var player_name = "Player"
@onready var absolute_parent = get_parent()
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var styleProgress = player.styleProgress
@onready var graze = player.graze

@export_group("Stats")
var speed = 150.0
var area_direction = Vector2(0, 0)
var grazed = false
var grazeDistance = 200
var timer = 0
# On spawn, set direction to where the player is right now
func _ready():
	sprite.play("shot")


# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(timer > 5):
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		hit(body)


# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
