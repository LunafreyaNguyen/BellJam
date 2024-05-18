extends Node

const shuriken = preload("res://Scenes/bullets/bulletShuriken.tscn")
@onready var shotTimer = $shotTimer2 as Timer
@onready var blast = $blast

var rotateSpeed = 40
var shootWaitTime = 0.1
var spawnPointCount = 20
var radius = 75
var waves = 0
var victoria
var player
signal patternDone

# Called when the node enters the scene tree for the first time.
func _ready():
	victoria = get_tree().get_first_node_in_group("Enemy")
	player = get_tree().get_first_node_in_group("Player")

func _on_shot_timer_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer && s != blast:
				var bullet = shuriken.instantiate()
				get_tree().root.add_child(bullet)
				bullet.position = s.global_position
				bullet.look_at(player.position)
		waves -= 1
		#blast.play()
	else:
		for s in self.get_children():
			if s != shotTimer && s != blast:
				s.queue_free()
				emit_signal("patternDone")


func start(_player, multiplier):
	victoria.targetLocation = Vector2(960, 100)
	waves = 10 * multiplier
	var step = 2 * PI / spawnPointCount
	
	for x in range(spawnPointCount):
		if(x < 10):
			var spawnPoint = Node2D.new()
			var pos = Vector2(radius, 0).rotated(step * x)
			spawnPoint.position = pos
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

func _process(_delta):
	pass
