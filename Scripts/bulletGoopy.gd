extends EnemyBullet

# On spawn, set direction to where the player is right now
func _ready():
	speed = 1200.0
	sprite.play("shot")


# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(timer > 15.0):
		queue_free()

# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
