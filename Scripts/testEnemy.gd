extends Enemy

@onready var pattern1 = $Pattern1
@onready var pattern2 = $Pattern2
@onready var pattern3 = $Pattern3
@onready var pattern4 = $Pattern4

## For testing only one pattern
var PATTERN_DEBUG_MODE = false
var debugPattern = pattern3
##############################

var rng = RandomNumberGenerator.new()
var targetLocation
var locations = []
var breakTimer
var totalPatterns = 4

# To be changed and made custom
func _ready():
	speed = 200
	health = 1000
	for s in get_tree().get_first_node_in_group("locations").get_children():
		locations.push_back(s)
	targetLocation = locations[0].position


func bossMovement(player):
	# Rotate to player
	if player != null && health > 0:
		if(self.position.x < player.get("position").x):
			sprite.set_rotation(.1)
		elif(self.position.x > player.get("position").x):
			sprite.set_rotation(-.1)
		else:
			sprite.set_rotation(0)


func bossShoot(player, multiplier):
	if(PATTERN_DEBUG_MODE):
		debugPattern.start(player, multiplier)
	else:
		var random:int = rng.randi_range(1, 4)
		#var random: int = 3 #this is just here cause debugger is broke rn
		
		match random:
			1: 
				pattern1.start(player, multiplier)
			2:
				pattern2.start(player, multiplier)
			3: 
				pattern3.start(player, multiplier)
			4:
				pattern4.start(player, multiplier)

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
	
	if self.position.distance_to(targetLocation) < 30:
		var random:int = rng.randi_range(0, locations.size() - 1)
		targetLocation = locations[random].position
		if player != null && !player.invulnerable:
			if (pattern1.getWaves() + pattern2.getWaves() + pattern3.getWaves()) + pattern4.getWaves() <= 1:
				timer = 0
				bossShoot(player, multiplier)
	elif (pattern1.getWaves() + pattern2.getWaves() + pattern3.getWaves()) <= 0 || health < 150:
		self.position = self.position.lerp(targetLocation, t)
	bossMovement(player)
	
	if get_tree().get_nodes_in_group("EnemyBullet").size() > 1000:
		get_tree().get_nodes_in_group("EnemyBullet")[0].queue_free()
	
	if health <= 0:
		for nodes in get_tree().get_nodes_in_group("EnemyBullet"):
			nodes.queue_free()
		die()
