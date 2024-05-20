extends Node

const bullet_pointed = preload("res://Scenes/bullets/bulletEnergyBall.tscn")
@onready var shotTimer = $shotTimer6 as Timer

var jugemu
var rotateSpeed = 90
var shootWaitTime = 0.1
var spawnPointCount = 6
var radius = 50
var waves = 0
var patternOn = true
@onready var rng = RandomNumberGenerator.new()
signal patternDone


# Called when the node enters the scene tree for the first time.
func _ready():
	jugemu = get_tree().get_first_node_in_group("Enemy")


func _on_shot_timer_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer:
				var bullet = bullet_pointed.instantiate()
				get_tree().root.add_child(bullet)
				bullet.position = s.global_position
				bullet.rotation = s.global_rotation
		waves -= 1
	else:
		for s in self.get_children():
			if s != shotTimer && is_instance_valid(s):
				s.queue_free()
				await(get_tree().create_timer(3).timeout)
				emit_signal("patternDone")


func start(_player, multiplier):
	await(get_tree().create_timer(2).timeout)
	jugemu.targetLocation = Vector2(rng.randi_range(700, 1300), 200)
	waves = 6 * (multiplier / 2)
	var step = 2 * PI / spawnPointCount
	for x in range(spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * x)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		self.add_child(spawnPoint)
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
func _process(delta):
	rotateSpawn(rotateSpeed, delta)