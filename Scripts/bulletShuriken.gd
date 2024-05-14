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


func _on_body_entered(body):
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	
	# make sure walls aren't destroyed!
	if body.is_in_group("Player"):
		hit(body)
	queue_free()

# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
