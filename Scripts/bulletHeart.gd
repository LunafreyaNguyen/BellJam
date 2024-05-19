extends EnemyBullet

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var release_timer = $"Wait Timer" as Timer
var scaleRate = Vector2(0.01, 0.01)
# On spawn, set direction to where the player is right now
func _ready():
	sprite.play("shot")
	speed = 0
	area_direction = Vector2(0, 0)
	release_timer.start()

# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(release_timer.time_left) > 0:
		look_at(player.position)
	else:
		scale += scaleRate
	if(timer > 4.0):
		queue_free()


func _on_timer_timeout():
	speed = 600
	release_timer.stop()


# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
