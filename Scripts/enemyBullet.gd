extends Area2D
class_name EnemyBullet

@onready var sprite = $Sprite2D

@export var player_name = "Player"
@onready var absolute_parent = get_parent()

@export_group("Stats")
var speed = 150.0
var area_direction = Vector2(0, 0)
var debounce = false


var timer = 0
# On spawn, set direction to where the player is right now
func _ready():
	sprite.play("shot")
	var player
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)


# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(timer > 5):
		queue_free()


func _on_body_entered(body):
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	
	if body.is_in_group("Player"):
		hit(body)
	if !body.is_in_group("Enemy"):
		queue_free()

# Make it hurt
func hit(body):
	body.hit()
