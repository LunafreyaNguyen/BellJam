extends Area2D

@onready var poof = $Poof

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
	# make sure walls aren't destroyed!
	makepoof()

# make the bullet disappear with a poof :D
func makepoof():
	poof.play(0)
	self.queue_free()

func hit():
	poof.play(0)
	self.queue_free()
