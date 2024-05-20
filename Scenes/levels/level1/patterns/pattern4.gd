extends Node

const bomb = preload("res://Scenes/bullets/bulletShurikenBomb.tscn")
@onready var shotTimer = $shotTimer4 as Timer


var rotateSpeed = 40
var shootWaitTime = .01
var spawnPointCount = 1
var radius = 75
var waves = 1
var victoria

signal patternDone

var static_pos
var static_rot 

func start(_player, _multiplier):
	victoria = get_tree().get_first_node_in_group("Enemy")
	victoria.targetLocation = Vector2(1200, 300)
	#waves = 30 * (multiplier / 2)
	waves = 1
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
	#once all bullets are spawned from spawner
	else:
		#print out children that exist now
		for s in self.get_children():
			if s != shotTimer:
				s.queue_free()
				await(get_tree().create_timer(.7).timeout)
				emit_signal("patternDone")


func getWaves():
	return waves

func setWaves(num):
	waves = num
