extends EnemyBullet


@onready var shotTimer: Timer = $shotTimer

const bulletShuriken = preload("res://Scenes/bullets/bulletShuriken.tscn")


var rotateSpeed = 40
var shootWaitTime = 2
var spawnPointCount = 50
var radius = 1
var waves = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("shot3")
	speed = 100
	await(get_tree().create_timer(shootWaitTime))
	start()


func _on_shot_timer_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer:
				var bullet = bulletShuriken.instantiate()
				get_tree().root.add_child(bullet)
				bullet.position = s.global_position
				bullet.rotation = s.global_rotation
				bullet.speed = 200
		waves -= 1
	else:
		for s in self.get_children():
			if s != shotTimer:
				s.queue_free()
	queue_free()


func start():
	var step = 2 * PI / spawnPointCount
	# Bullet travels for a timer
	# Once timer elapses
	# Spawn and spin shurikens
	# Die
	for x in range(spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * x)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		self.add_child(spawnPoint)
		
	shotTimer.wait_time = shootWaitTime
	shotTimer.start()


func rotateSpawn(rotate, time):
	var newRotation = self.rotation_degrees + (rotate * time)
	self.rotation_degrees = fmod(newRotation, 360)
	

# Make it hurt
func hit(body):
	if body.isInvulnerable():
		return
	else:
		body.hit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * delta * speed
	if(position.x < 500 || position.x > 1420):
		queue_free()
	if(position.y < 0 || position.y > 1080):
		queue_free()
