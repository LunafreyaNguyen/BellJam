extends Enemy

# To be changed and made custom
func _ready():
	speed = 100
	health = 300
	fireRate = 1.2

func bossMovement(player, delta):
	# These 3 little lines of code handle movement! Don't ask me why velocity has to be set this way.
	if player != null && health > 0:
		self.velocity = Vector2(0, 0)
		self.position.x = move_toward(self.position.x, player.get("position").x, speed * delta)
		
		if(self.position.x < player.get("position").x):
			sprite.set_rotation(.1)
		elif(self.position.x > player.get("position").x):
			sprite.set_rotation(-.1)
		else:
			sprite.set_rotation(0)
	move_and_slide()
	
func bossShoot(player, delta):
	var waves = 10;
	var burstFire = .05
	var bulletSpawn = get_node("bulletSpawn")
	var spawnPosition = bulletSpawn.get("global_position")
	var waveMove = []
	for x in waves:
		waveMove.push_back((x-5) * 2)
	while waves > 0:
		await get_tree().create_timer(burstFire).timeout
		for x in 5:
			var temp = enemyBullet.instantiate()
			var xPos = [-65, -25, 0, 25, 50]
			var yPos = [10, 30, 50, 30, 10]
			add_sibling(temp)
			var thisSpawn = Vector2(spawnPosition.x - waveMove[x], spawnPosition.y)
			temp.global_position = bulletSpawn.get("global_position")
			temp.global_position = Vector2(temp.global_position.x + xPos[x], temp.global_position.y + yPos[x])
			temp.area_direction = Vector2(temp.global_position - thisSpawn).normalized()
		waves -= 1

func _physics_process(delta):
	timer += delta
	fireRate = (health + 150) / 300.0
	# Gets the player object to be referenced in movement scripts
	var player
	if absolute_parent.get_node_or_null(player_name) != null:
		player = absolute_parent.get_node(player_name)
	
	# To be modified and made custom
	bossMovement(player, delta)
	if timer > fireRate:
		bossShoot(player, delta)
		timer = 0
	if health <= 0:
		die()
