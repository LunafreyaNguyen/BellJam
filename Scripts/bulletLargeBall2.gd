extends EnemyBullet

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var release_timer = $"Wait Timer" as Timer

# On spawn, set direction to where the player is right now
func _ready():
	debounce = false
	sprite.play("shot")
	speed = 0
	area_direction = Vector2(0, 0)
	release_timer.start()

# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(release_timer.time_left) > 0:
		pass
	if(timer > 4.0):
		queue_free()

func _on_wait_timer_timeout():
	speed = -1200
	release_timer.stop()

func _on_body_entered(body):
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	
	# make sure walls aren't destroyed!
	if body.is_in_group("Player"):
		hit(body)
	elif body.is_in_group("Enemy"):
		return
	queue_free()

# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()
