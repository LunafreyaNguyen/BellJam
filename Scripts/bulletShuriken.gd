extends EnemyBullet

# On spawn, set direction to where the player is right now
func _ready():
	speed = 400.0
	area_direction = Vector2(0, 0)
	debounce = false
	sprite.play("shot3")


# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(timer > 4.0):
		queue_free()
	if(position.x < 500 || position.x > 1420):
		queue_free()
	if(position.y < 0 || position.y > 1080):
		queue_free()

# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
