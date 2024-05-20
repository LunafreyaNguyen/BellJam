extends EnemyBullet

@onready var release_timer = $"Wait Timer" as Timer

# On spawn, set direction to where the player is right now
func _ready():
	sprite.play("shot")
	speed = 500
	area_direction = Vector2(0, 0)
	release_timer.start()

# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if speed > -1200:
		speed += -750 * delta
	if(release_timer.time_left) > 0:
		pass
	if(timer > 10.0):
		queue_free()

func _on_wait_timer_timeout():
	speed = -1200
	release_timer.stop()


# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
