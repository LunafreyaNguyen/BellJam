extends Enemy

@onready var rotater1 = $Rotater1
@onready var rotater2 = $Rotater2
@onready var shotTimer1 = $shotTimer1
@onready var shotTimer2 = $shotTimer2

const shuriken = preload("res://Scenes/bulletShuriken.tscn")
const bulletCircle = preload("res://Scenes/enemyBullet.tscn")

var rotateSpeed = 100
var waves1 = 0
var waves2 = 0
var targetLocation
var locations = []
var breakTimer

# To be changed and made custom
func _ready():
	speed = 200
	health = 1000
	fireRate = 1.2
	for s in get_tree().get_first_node_in_group("locations").get_children():
		locations.push_back(s)
	targetLocation = locations[0].position


func bossMovement(player, delta):
	# These 3 little lines of code handle movement! Don't ask me why velocity has to be set this way.
	if player != null && health > 0:
		if(self.position.x < player.get("position").x):
			sprite.set_rotation(.1)
		elif(self.position.x > player.get("position").x):
			sprite.set_rotation(-.1)
		else:
			sprite.set_rotation(0)
	move_and_slide()
	
	
func bossShoot(player, delta, multiplier):
	randomize()
	var patterns = [1,2]
	var random:int = randi() % patterns.size()
	if random == 1:
		pattern1(player, delta, multiplier)
	else:
		pattern2(player, delta, multiplier)


func pattern1(player, delta, multiplier):
	rotateSpeed = 40
	var shootWaitTime = 0.15
	var spawnPointCount = 8
	var radius = 75
	waves1 = 30 * (multiplier / 2)
	var step = 2 * PI / spawnPointCount

	for x in range(spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * x)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		rotater1.add_child(spawnPoint)
		
	shotTimer1.wait_time = shootWaitTime
	shotTimer1.start()


func pattern2(player, delta, multiplier):
	rotateSpeed = 0
	var shootWaitTime = 0.1
	var spawnPointCount = 20
	var radius = 75
	waves2 = 4 * multiplier
	var step = 2 * PI / spawnPointCount
	
	for x in range(spawnPointCount):
		if(x < 10):
			var spawnPoint = Node2D.new()
			var pos = Vector2(radius, 0).rotated(step * x)
			spawnPoint.position = pos
			spawnPoint.rotation = pos.angle()
			rotater2.add_child(spawnPoint)
		
	shotTimer2.wait_time = shootWaitTime
	shotTimer2.start()

func _physics_process(delta):
	timer += delta
	
	# Gets the player object to be referenced in movement scripts
	var player
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)
	
	var newRotation1 = rotater1.rotation_degrees + (rotateSpeed * delta)
	rotater1.rotation_degrees = fmod(newRotation1, 360)
	
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
		var patterns = [1,2,3,4]
		var random:int = randi() % patterns.size()
		targetLocation = locations[random].position
		if player != null && !player.invulnerable:
			if waves1 + waves2 <= 10:
				timer = 0
				bossShoot(player, delta, multiplier)
		else:
			waves1 = 0
			waves2 = 0
	elif waves1 + waves2 <= 0 || health < 200:
		self.position = self.position.lerp(targetLocation, t)
	
	# To be modified and made custom
	bossMovement(player, delta)
	
	if get_tree().get_nodes_in_group("EnemyBullet").size() > 500:
		get_tree().get_nodes_in_group("EnemyBullet")[0].queue_free()
	
	if health <= 0:
		for nodes in get_tree().get_nodes_in_group("EnemyBullet"):
			nodes.queue_free()
		die()


func _on_shot_timer_1_timeout():
	if waves1 > 0:
		for s in rotater1.get_children():
			var bullet = bulletCircle.instantiate()
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		waves1 -= 1
	else:
		for s in rotater1.get_children():
			s.queue_free()


func _on_shot_timer_2_timeout():
	if waves2 > 0:
		for s in rotater2.get_children():
			var bullet = shuriken.instantiate()
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		waves2 -= 1
	else:
		for s in rotater2.get_children():
			s.queue_free()
