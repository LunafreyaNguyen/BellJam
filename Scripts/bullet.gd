extends Area2D
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

const speed = 2500.0
var area_direction = Vector2(0, 0)
var debounce = false
	
var timer = 0

func ready():
	sprite.play("default")

func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if timer > 4:
		queue_free()
	if(position.x < 500 || position.x > 1420):
		queue_free()
	if(position.y < 0 || position.y > 1080):
		queue_free()

func _on_body_entered(body):	
	# Stops an error that crashes the game.
	hit(body)

# Delete the bullet, lower enemy's HP
func hit(body):
	if body.is_in_group("Enemy"):
		body.hit()
		player.styleProgress += 1
	if!(body.is_in_group("bullet")):
		queue_free()
