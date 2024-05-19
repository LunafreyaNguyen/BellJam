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
@onready var sprite = $Sprite2D as Sprite2D
@onready var hurtbox = $CollisionShape2D as CollisionShape2D
@onready var hit_anim = $HitFlash as AnimationPlayer

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
func hit(damage):
	health -= damage
	hit_anim.play("hurt")
	
# For dying
func die():
	get_tree().change_scene_to_file("res://Scenes/levels/testCowboy.tscn")
	#self.queue_free()

# To be modified by boss code
func _physics_process(_delta):
	# Gets the player object to be referenced in movement scripts
	var player
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)
	
	# To be modified and made custom
	bossMovement(player)
