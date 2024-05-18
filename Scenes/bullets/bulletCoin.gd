extends Area2D

@onready var sprite = $Sprite2D

@export var player_name = "Player"
@onready var absolute_parent = get_parent()

@export_group("Stats")
var speed = 350.0
var area_direction = Vector2(0, 0)
var debounce = false


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
	if(position.x < 500 || position.x > 1420):
		queue_free()
	if(position.y < 0 || position.y > 1080):
		queue_free()


func _on_body_entered(body):
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	if body.is_in_group("Player"):
		hit(body)
	if !body.is_in_group("Enemy") || body.is_in_group("bounds"):
		queue_free()


# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()