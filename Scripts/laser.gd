extends Area2D
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

const speed = 2500.0
var area_direction = Vector2(0, 0)
var debounce = false
var progress = .05
	
var timer = 0

func ready():
	sprite.play("default")

func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if timer > 4:
		queue_free()


func _on_body_entered(body):	
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	hit(body)

# Delete the bullet, lower enemy's HP
func hit(body):
	if body.is_in_group("Enemy"):
		body.hit(progress)
		player.styleProgress += progress
