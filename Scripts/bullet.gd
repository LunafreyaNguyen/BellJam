extends Area2D
@onready var sprite = $Sprite2D

const speed = 2500.0
var area_direction = Vector2(0, 0)
var debounce = false
	
var timer = 0

func ready():
	sprite.play("default")

func _process(delta):
	timer += delta
	self.translate(Vector2(0, -1) * speed * delta)
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
		body.hit()
	queue_free()
