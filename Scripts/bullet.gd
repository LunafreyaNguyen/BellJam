extends Area2D

const speed = 2500.0
var area_direction = Vector2(0, 0)
var debounce = false
	

func _process(delta):
	self.translate(Vector2(0, -1) * speed * delta)

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
	self.queue_free()
