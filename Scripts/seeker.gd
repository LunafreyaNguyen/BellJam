extends Area2D
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var enemy = get_tree().get_first_node_in_group("Enemy")
const speed = 1000.0
var area_direction = Vector2(0, 0)
var debounce = false
var progress = .02

var timer = 0

func ready():
	if enemy != null:
		self.look_at(enemy)
	
	
func animationPlay():
	sprite.play()
	

func _process(delta):
	rotation = lerp_angle(rotation, rotation + get_angle_to(enemy.position), .2)
	timer += delta
	position += transform.x * speed * delta

	if timer > 10:
		queue_free()

func _on_body_entered(body):	
	# Stops an error that crashes the game.
	hit(body)

# Delete the bullet, lower enemy's HP
func hit(body):
	if body.is_in_group("Enemy"):
		body.hit(progress)
		player.styleProgress += progress
	if!(body.is_in_group("bullet")):
		queue_free()
