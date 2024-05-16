extends Node

const bomb = preload("res://Scenes/bullets/bulletShurikenBomb.tscn")
@onready var shotTimer = $shotTimer4 as Timer


var rotateSpeed = 40
var shootWaitTime = .01
var spawnPointCount = 1
var radius = 75
var waves = 10

var static_pos
var static_rot 

func start(_player, multiplier):
	#waves = 30 * (multiplier / 2)
	var step = 2 * PI / spawnPointCount
	waves = 10
	for x in range(spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(PI/2)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		self.add_child(spawnPoint)
		
	for s in self.get_children():
		#get initial position of bullet spawn point so all bullets can come from one spot
		if s!= shotTimer:
			static_pos = s.global_position
			static_rot = s.global_rotation
	shotTimer.wait_time = shootWaitTime
	shotTimer.start()
	
func rotateSpawn(rotate, time):
	var newRotation = self.rotation_degrees + (rotate * time)
	self.rotation_degrees = fmod(newRotation, 360)


func _on_shot_timer_4_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer:
				var bullet = bomb.instantiate()
				get_tree().root.add_child(bullet)
				#setposition of bullets to just one spot
				bullet.position = static_pos
				bullet.rotation = static_rot
				bullet.add_to_group("mannyBall")
				
		waves -= 1
		print(get_tree().get_nodes_in_group("mannyBall"))
		print(" ")
		
		print("speen")
		var counter = 0
		var step = 2 * PI / waves
		for orbs in get_tree().get_nodes_in_group("mannyBall"):
			var stepmod = fmod(counter,10)
			print(" ")
			print(stepmod)
			print(" ")
			
			orbs.rotation = orbs.position.rotated(0).angle()
			counter += 1 
	#once all bullets are spawned from spawner
		
	else:
		#print out children that exist now
		
		for s in self.get_children():
			if s != shotTimer:
				s.queue_free()
	
	

