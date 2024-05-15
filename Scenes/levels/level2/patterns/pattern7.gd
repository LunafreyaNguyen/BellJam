extends Node

const bullet_pointed = preload("res://Scenes/bullets/bulletOscillating.tscn")
@onready var shotTimer = $shotTimer7 as Timer

var rotateSpeed = 90
var shootWaitTime = 0.1
var spawnPointCount = 20
var radius = 75
var waves = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
			if s != shotTimer:
				s.queue_free()


func start(_player, multiplier):
	waves = 1 * (multiplier / 2)
	var step = 2 * PI / spawnPointCount

	for x in range(spawnPointCount):
		if(x < 20):
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
func _process(_delta):
	pass
