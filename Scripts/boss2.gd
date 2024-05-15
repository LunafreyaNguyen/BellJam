extends Enemy

@onready var pattern1 = $Pattern5
@onready var pattern2 = $Pattern6
@onready var pattern3 = $Pattern7

## For testing only one pattern
var PATTERN_DEBUG_MODE = false
var debugPattern = pattern1
##############################

var rng = RandomNumberGenerator.new()
var targetLocation
var locations = []
var breakTimer
var totalPatterns = 3

# To be changed and made custom
func _ready():
	speed = 200
	health = 1000
	for s in get_tree().get_first_node_in_group("locations").get_children():
		locations.push_back(s)
	targetLocation = locations[0].position


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
	
	
func bossShoot(player, multiplier):
	if(PATTERN_DEBUG_MODE):
		debugPattern.start(player, multiplier)
	else:
		var random:int = rng.randi_range(1, 3)
		#var random: int = 3 #this is just here cause debugger is broke rn
		
		match random:
			1: 
				pattern1.start(player, multiplier)
			2:
				pattern2.start(player, multiplier)
			3: 
				pattern3.start(player, multiplier)

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
			if (pattern1.getWaves() + pattern2.getWaves() + pattern3.getWaves()) <= 10:
				timer = 0
				bossShoot(player, multiplier)
		else:
			pattern1.setWaves(0)
			pattern2.setWaves(0)
			pattern3.setWaves(0)
	elif (pattern1.getWaves() + pattern2.getWaves() + pattern3.getWaves()) <= 0 || health < 200:
		self.position = self.position.lerp(targetLocation, t)
	
	# To be modified and made custom
	bossMovement(player)
	
	if get_tree().get_nodes_in_group("EnemyBullet").size() > 500:
		get_tree().get_nodes_in_group("EnemyBullet")[0].queue_free()
	
	if health <= 0:
		for nodes in get_tree().get_nodes_in_group("EnemyBullet"):
			nodes.queue_free()
		die()
