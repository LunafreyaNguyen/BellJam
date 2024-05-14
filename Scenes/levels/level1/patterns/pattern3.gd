extends Node

const largeBall = preload("res://Scenes/bullets/bulletLargeBall.tscn")
@onready var shotTimer = $shotTimer3 as Timer

var rotateSpeed = 40
var shootWaitTime = 0.45
var spawnPointCount = 12
var radius = 75
var waves = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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


func start(_player, multiplier):
	waves = 30 * (multiplier / 2)
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
