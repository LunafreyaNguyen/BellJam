extends Enemy

@onready var pattern1 = $Pattern5
@onready var pattern2 = $Pattern6
@onready var pattern3 = $Pattern7
@onready var pattern4 = $Pattern8

## For testing only one pattern
var PATTERN_DEBUG_MODE = false
var debugPattern = pattern1
##############################
var dieParticle = false
const deathParticles = preload("res://Scenes/bonnie_death_particles.tscn")

var rng = RandomNumberGenerator.new()
var targetLocation
var locations = []
var breakTimer
var lastPattern = 1
var shooting = false

func _ready():
	health = 15000
	for s in get_tree().get_first_node_in_group("locations").get_children():
		locations.push_back(s)
	targetLocation = locations[4].position


# Rotate to player
func bossMovement(player):
	if player != null && health > 0:
		if(self.position.x < player.get("position").x):
			sprite.set_rotation(.1)
		elif(self.position.x > player.get("position").x):
			sprite.set_rotation(-.1)
		else:
			sprite.set_rotation(0)
	
	
# Picks the pattern
func bossShoot(player, multiplier):
	shooting = true
	if(PATTERN_DEBUG_MODE):
		debugPattern.start(player, multiplier)
	else:
		var random:int = rng.randi_range(1, 4)
		while random == lastPattern:
			random = rng.randi_range(1, 4)
		lastPattern = random
		#var random: int = 3 #this is just here cause debugger is broke rn
		match random:
			1: 
				pattern1.start(multiplier)
				await(pattern1.patternDone)
			2:
				pattern2.start(player, multiplier)
				await(pattern2.patternDone)
			3: 
				pattern3.start(player, multiplier)
				await(pattern3.patternDone)
			4:
				pattern4.start(player, multiplier)
				await(pattern4.patternDone)
	await(get_tree().create_timer(2).timeout)
	shooting = false
	
	
func _physics_process(delta):
	timer += delta
	
	# Gets the player object to be referenced in movement scripts
	var player
	if absolute_parent.get_node_or_null("Player") != null:
		player = absolute_parent.get_node("Player")
	
	var t = 0
	var multiplier
	if health < 200:
		multiplier = 4
		breakTimer = .5
	elif health < 600:
		multiplier = 3
		breakTimer = 1
	else:
		multiplier = 2
		breakTimer = 2
	t += delta * multiplier
	
	# Once close enough to the location, shoot if player exists and no pattern currently being shot
	if self.position.distance_to(targetLocation) < 5:
		if player != null && !player.invulnerable:
			if !shooting:
				bossShoot(player, multiplier)
	# Faces the boss towards the player
	bossMovement(player)
	if shooting:
		self.position = self.position.lerp(targetLocation, t*4)
	else:
		self.position = self.position.lerp(targetLocation, t)
	# Delete some nodes if there are over a thousand of them
	if get_tree().get_nodes_in_group("EnemyBullet").size() > 2000:
		get_tree().get_nodes_in_group("EnemyBullet")[0].queue_free()
	
	# If boss's health is below 0
	if health <= 0:
		for nodes in get_tree().get_nodes_in_group("EnemyBullet"):
			nodes.queue_free()
		die()


func die():
	if !dieParticle:
		var particle = deathParticles.instantiate()
		particle.position = global_position
		particle.rotation = rotation
		particle.emitting = true
		get_tree().current_scene.add_child(particle)
		dieParticle = !dieParticle
		for nodes in get_tree().get_nodes_in_group("pattern"):
			nodes.queue_free()
		visible = false
	await(get_tree().create_timer(3).timeout)
	get_tree().change_scene_to_file("res://Dialogue/Cowboy/cowboyOutro.tscn")


func _on_hitboxarea_body_entered(body):
	if body.is_in_group("Player"):
		if body.isInvulnerable():
			return
		else:
			body.hit()
