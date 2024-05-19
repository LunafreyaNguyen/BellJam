extends Node

const bomb = preload("res://Scenes/bullets/bulletShurikenBomb.tscn")
@onready var shotTimer = $shotTimer6

#declare variables necessary for projectile spawner
var rotateSpeed = 40
var shootWaitTime = .01
var spawnPointCount = 1
var radius = 75
var waves = 3

var boss
var locations = [ Vector2(1220, 200), Vector2(700, 200)]
#signal for once pattern is complete
signal patternDone
signal moveDone

#grabbing enemy object to work with

func _ready():
	boss = get_tree().get_first_node_in_group("Enemy")
	#TODO connect parry functions to pattern
	pass

func _on_shot_timer_timeout():
	if waves > 0:
		for s in self.get_children():
			if s != shotTimer:
				var bullet = bomb.instantiate()
				get_tree().root.add_child(bullet)
				bullet.position = s.global_position
				bullet.rotation = s.global_rotation
		waves -= 1
	else:
		for s in self.get_children():
			if s != shotTimer:
				s.queue_free()
#function to take initial process start and end of pattern
func start(_player,multiplier):
	#call move function to move boss and initiate bullet firing
	#after movement method is complete,signal that pattern is complete
	move()
	print("move done")
	await(moveDone)
	emit_signal("patternDone")

#function to move enemy from one target location, to another to complete pattern
func move():
	boss.targetLocation = locations[0]
	await(get_tree().create_timer(1.0).timeout)
	boss.targetLocation = locations[1]
	emit_signal("moveDone")



func _process(delta):
	if get_tree() == null:
		queue_free()
	#rotateSpawn(rotateSpeed, delta)
	pass

