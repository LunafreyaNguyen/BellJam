extends Node


const coin = preload("res://Scenes/bullets/bulletCoin.tscn")
@onready var boss = get_tree().get_nodes_in_group("Enemy")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var shotTimer = $shotTimer1 as Timer
@onready var chargeStart = $chargeStart
@onready var chargeImpact = $chargeImpact


var victoria
var rotateSpeed = 40
var shootWaitTime = 0.15
var spawnPointCount = 15
var radius = 75
var waves = 0
var patternOn = true
var locations = [Vector2(960, 200), Vector2(1220, 200), Vector2(700, 200)]
var chargeLocations = [Vector2(960, 980), Vector2(1220, 980), Vector2(700, 980)]
var newTargetLocation = locations[0]
var parried = false
signal chargeCompleted
signal patternDone


# Called when the node enters the scene tree for the first time.
func _ready():
	parried = false
	victoria = get_tree().get_first_node_in_group("Enemy")
	player.parryCancel.connect(gotParried)
	pass # Replace with function body.


func _on_shot_timer_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer && s != chargeStart && s!= chargeImpact:
				var bullet = coin.instantiate()
				get_tree().root.add_child(bullet)
				bullet.position = s.global_position
				bullet.rotation = s.global_rotation
		waves -= 1
	else:
		for s in self.get_children():
			if s != shotTimer && s!= chargeStart && s!= chargeImpact:
				s.queue_free()


func charge(locationNum):
	victoria.targetLocation = locations[locationNum]
	chargeStart.play()
	await(get_tree().create_timer(.7).timeout)
	victoria.targetLocation = Vector2(locations[locationNum].x, locations[locationNum].y - 100)
	await(get_tree().create_timer(.5).timeout)
	victoria.targetLocation = chargeLocations[locationNum]
	await(get_tree().create_timer(.15).timeout)
	if(!parried):
		spawnSet()
		chargeImpact.play()
	await(get_tree().create_timer(.8).timeout)
	victoria.targetLocation = locations[locationNum]
	await(get_tree().create_timer(.4).timeout)
	emit_signal("chargeCompleted")

func start(_player):
	parried = false
	# Charge middle, right, left
	for s in range(0, 3):
		if !parried:
			charge(s)
			await(chargeCompleted)
	parried = false
	emit_signal("patternDone")
	
func spawnSet():
	waves = 1
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

func gotParried():
	parried = true

func rotateSpawn(rotate, time):
	var newRotation = self.rotation_degrees + (rotate * time)
	self.rotation_degrees = fmod(newRotation, 360)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree() == null:
		queue_free()
	#rotateSpawn(rotateSpeed, delta)
	pass
