extends EnemyBullet

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var oscillating_timer = $"Wait Timer" as Timer
var oscillating = true
var scaleRate = Vector2(0.0, 0.0)
# On spawn, set direction to where the player is right now
func _ready():
	debounce = false
	sprite.play("shot")
	speed = 300
	area_direction = Vector2(0.0, 0.0)
	oscillating_timer.start()

# Move in the initial direction
func _process(delta):
	timer += delta
	position += transform.x * speed * delta
	if(oscillating_timer.wait_time > 0):
		if(oscillating):  
			scale += scaleRate
		else: 
			scale -= scaleRate
	if(timer > 5.0):
		queue_free()

func _on_wait_timer_timeout():
	oscillating_timer.stop()
	oscillating = !oscillating
	speed *= -1
	oscillating_timer.start()

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
