extends EnemyBullet

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var oscillating_timer = $"Wait Timer" as Timer
var oscillating = true
var scaleRate = Vector2(0.0, 0.0)
# On spawn, set direction to where the player is right now
func _ready():
	sprite.play("shot")
	speed = 500
	area_direction = Vector2(0.0, 0.0)
	oscillating_timer.start()

# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	speed = speed - (300 * delta)
	if(timer > 5.0):
		queue_free()


func _on_wait_timer_timeout():
	pass


# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
