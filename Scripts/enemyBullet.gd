extends Area2D
class_name EnemyBullet

@onready var sprite = $Sprite2D

@export var player_name = "Player"
@onready var absolute_parent = get_parent()

@export_group("Stats")
const speed = 500.0
var area_direction = Vector2(0, 0)
var debounce = false
var timer = 0
# On spawn, set direction to where the player is right now
func _ready():
	sprite.play("shot")
	var player
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)
	

# Move in the initial direction
func _process(delta):
	timer += delta
	self.translate(self.area_direction * speed * delta)
	self.look_at(self.global_position + self.area_direction)
	if(timer > 7.0):
		self.queue_free()

func _on_body_entered(body):	
	# Stops an error that crashes the game.
	if debounce == true:
		return
	debounce = true
	# make sure walls aren't destroyed!
	hit(body)

# Delete the Bullet
func hit(body):
	if body.is_in_group("Player"):
		body.hit()
	self.queue_free()
