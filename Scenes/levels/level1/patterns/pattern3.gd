extends Node

const largeBall = preload("res://Scenes/bullets/bulletLargeBall.tscn")
@onready var shotTimer = $shotTimer3 as Timer

var rng = RandomNumberGenerator.new()
var rotateSpeed = 100
var shootWaitTime = 0.2
var spawnPointCount = 18
var radius = 75
var waves = 0
var victoria
signal patternDone

# Called when the node enters the scene tree for the first time.
func _ready():
	victoria = get_tree().get_first_node_in_group("Enemy")


func _on_shot_timer_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer:
				var bullet = largeBall.instantiate()
				get_tree().root.add_child(bullet)
				bullet.position = s.global_position
				bullet.rotation = s.global_rotation
		waves -= 1
	else:
		for s in self.get_children():
			if s != shotTimer:
				s.queue_free()
				emit_signal("patternDone")


func start(_player, multiplier):
	var random:int = rng.randi_range(1, 5)
	victoria.targetLocation = Vector2(500 + (100 * random), 300)
	waves = 5 * (multiplier / 2)
	var step = 2 * PI / spawnPointCount

	for x in range(spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * x)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		self.add_child(spawnPoint)
		
	rotateSpawn(rotateSpeed, 1)
	shotTimer.wait_time = shootWaitTime
	shotTimer.start()


func getWaves():
	return waves


func setWaves(num):
	waves = num

func rotateSpawn(rotate, time):
	var newRotation = self.rotation_degrees + (rotate * time)
	self.rotation_degrees = fmod(newRotation, 360)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotateSpawn(rotateSpeed, _delta)
