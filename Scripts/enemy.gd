extends CharacterBody2D

class_name Enemy

# Stats to be modified in each Boss
@export_group("Stats")
@export var speed = 100
@export var health: int = 50
@export var fireRate = 1.2

# For getting the player and sprite
@onready var absolute_parent = get_parent()
@export var player_name = "Player"
@onready var sprite = $Sprite2D
@onready var hurtbox = $CollisionShape2D

# For use with delta
var timer = 0

# For general movement of the boss
func bossMovement(player):
	# These 3 little lines of code handle movement! Don't ask me why velocity has to be set this way.
	if player != null && health > 0:
		if(self.position.x < player.get("position").x):
			sprite.set_rotation(.1)
		elif(self.position.x > player.get("position").x):
			sprite.set_rotation(-.1)
		else:
			sprite.set_rotation(0)
	move_and_slide()

# For getting hit
func hit():
	health -= 1
	
	
# For dying
func die():
	self.queue_free()

# To be modified by boss code
func _physics_process(delta):
	# Gets the player object to be referenced in movement scripts
	var player
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)
	
	# To be modified and made custom
	bossMovement(player)
