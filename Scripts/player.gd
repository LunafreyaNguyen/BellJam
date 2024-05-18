extends CharacterBody2D

@export var Bullet: PackedScene
@onready var bulletSpawnM = $bulletSpawn1
@onready var bulletSpawnL = $bulletSpawn2
@onready var bulletSpawnR = $bulletSpawn3
@onready var sprite = $Sprite2D
@onready var hit_box = $CollisionShape2D/HitBox
@onready var focus_bar = $"Focus Bar"

const deathParticles = preload("res://Scenes/death_particles.tscn")

@onready var rankUpNoise = $SFX/rankUpNoise
@onready var rankUp2Noise = $SFX/rankUp2Noise
@onready var rankDownNoise = $SFX/rankDownNoise
@onready var rankDown2Noise = $SFX/rankDown2Noise
@onready var deathNoise = $SFX/deathNoise

const styleS = preload("res://Art/style/S.png")
const styleA = preload("res://Art/style/A.png")
const styleB = preload("res://Art/style/B.png")
const styleC = preload("res://Art/style/C.png")
const styleD = preload("res://Art/style/D.png")

@onready var styles = [styleD, styleC, styleB, styleA, styleS]
@onready var currStyle = 1
@onready var styleProgress = 0
@onready var styleConstant = get_tree().get_first_node_in_group("styleConstant")
@onready var styleExplosion = get_tree().get_first_node_in_group("styleExplosion")

@onready var Camera = get_tree().get_first_node_in_group("Camera")
@onready var style = get_tree().get_first_node_in_group("style")
@onready var styleGauge = get_tree().get_first_node_in_group("styleGauge")

@export var start_level = load("res://Scenes/levels/testLuna.tscn") as PackedScene
@onready var parry_timer = $ParryTimer
@onready var parryHitbox = $ParryHitbox
@onready var parry_cd_indicator = get_tree().get_first_node_in_group("parryIndicator")
@onready var parry_follow = $ParryFollow
const FOLLOW_SPEED : float = 3.0
@onready var parrySlash = get_tree().get_first_node_in_group("parrySlash")
@onready var collision_shape_2d = $CollisionShape2D
@onready var parryCooldown = $ParryCooldown
@onready var parryShine = $SFX/parryShine
@onready var laugh = $SFX/laugh

signal parryCancel

# Character's stats
@export_group("Stats")
@export var speed = 450.0
@export var fireRate = .1
var dead: bool = false
var timer = 0
@export var invulnerable = false
var isParrying = false
var parryOff = false

# Called when the node enters the scene tree for the first time.
func _ready():
	parryHitbox.modulate.a = 0
	parryHitbox.play()
	changeHitboxSize()

func get_input():
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	if !dead:
		velocity = input_direction * speed
		if(input_direction.x > 0):
			sprite.set_rotation(.3)
		elif(input_direction.x < 0):
			sprite.set_rotation(-.3)
		else:
			sprite.set_rotation(0)
		sprite.modulate.a = 1.0
		hit_box.visible = false
		if Input.get_action_raw_strength("parry") && !isParrying && !parryOff:
			isParrying = true
			var whiteTween: Tween = create_tween()
			whiteTween.tween_property(self, "modulate:v", 1, 0.25).from(15)
			parryShine.play()
			parry_timer.start()
		if Input.get_action_raw_strength("focus") && focus_bar.get_burnout_condition() == false:
			velocity = velocity * .5
			focus_bar.add_value(15)
			hit_box.visible = true
			sprite.modulate.a = .4
		elif(focus_bar.get_burnout_condition() == false):
			focus_bar.decrease_value(20)
			hit_box.visible = false

func _on_parry_timer_timeout():
	isParrying = false
	parryOff = true
	if(parry_cd_indicator != null):
		parry_cd_indicator.visible = false
	parryCooldown.start()
	parry_timer.stop()

func parryCooldownTimeout():
	if(parry_cd_indicator != null):
		parry_cd_indicator.visible = true
	parryOff = false

func hit():
	if isParrying:
		parrySlash.parry()
		emit_signal("parryCancel")
		#laugh.play()
		var parryHitboxTween: Tween = create_tween()
		parryHitboxTween.tween_property(parryHitbox, "modulate:a", 0, .5).from(1)
		for s in get_tree().get_nodes_in_group("EnemyBullet"):
			if s.position.distance_to(position) < (currStyle * 100 + 100):
				s.queue_free()
		if currStyle < 4:
			currStyle += 1
			rankUpNoise.playPitch((currStyle/5 + 1), .22)
			rankUp2Noise.play()
			if(styleExplosion.is_emitting()):
				styleExplosion.set_emitting(false)
			styleExplosion.set_emitting(true)
			changeHitboxSize()
		else:
			rankUpNoise.playPitch((currStyle/5 + 1), .22)
			rankUp2Noise.play()
			styleProgress = 100
			if(styleExplosion.is_emitting()):
				styleExplosion.set_emitting(false)
			styleExplosion.set_emitting(true)
	elif !invulnerable:
		if currStyle == 0 && !dead:
			dead = true
			parry_cd_indicator.queue_free()
			var particle = deathParticles.instantiate()
			particle.position = global_position
			particle.rotation = rotation
			particle.emitting = true
			get_tree().current_scene.add_child(particle)
			for child in self.get_children():
				if child is Sprite2D:
					child.visible = false
				elif child is CollisionShape2D:
					child.set_deferred("disabled", true)
			deathNoise.play()
			velocity = Vector2(0, 0)
			await get_tree().create_timer(4, true, false, true).timeout
			for s in get_tree().get_nodes_in_group("EnemyBullet"):
				s.queue_free()
			get_tree().get_first_node_in_group("GameOverScreen").visible = true
			styleProgress = 0
		else:
			if currStyle >= 2:
				currStyle -= 2
			else:
				currStyle = 0
			styleProgress = 0
			changeHitboxSize()
			rankDownNoise.play()
			rankDown2Noise.play()
			Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
			invulnerable = true
			for nodes in get_tree().get_nodes_in_group("EnemyBullet"):
				nodes.queue_free()
			var playerPortrait = get_tree().get_first_node_in_group("PlayerPortrait")
			playerPortrait.visible = not playerPortrait.visible
			for x in 8:
				Camera.set("offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)))
				sprite.visible = not sprite.visible
				await get_tree().create_timer(.05, true, false, true).timeout
			playerPortrait.visible = not playerPortrait.visible
			Camera.set("offset", Vector2(0, 0))
			invulnerable = false


func changeHitboxSize():
	var newParrySize = ((currStyle/4.0)) * 30 + 10
	if currStyle == 0:
		newParrySize = 10
	parryHitbox.scale.x = newParrySize
	parryHitbox.scale.y = newParrySize * 1.4


func isInvulnerable():
	return invulnerable

func isDead():
	return dead

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if styleProgress > 100:
		if currStyle < 4:
			currStyle += 1
			rankUpNoise.playPitch((currStyle/5 + 1), .22)
			rankUp2Noise.play()
			styleProgress = 0
			if(styleExplosion.is_emitting()):
				styleExplosion.set_emitting(false)
			styleExplosion.set_emitting(true)
			changeHitboxSize()
		else:
			styleProgress = 100
	style.set_texture(styles[currStyle])
	styleGauge.value = styleProgress
	styleConstant.set_amount(currStyle * 100 + 100)
	timer += delta
	if(parry_cd_indicator != null):
		parry_cd_indicator.global_position = parry_cd_indicator.global_position.lerp(parry_follow.global_position, delta * FOLLOW_SPEED)
		parry_cd_indicator.look_at(self.position)
	get_input()
	move_and_slide()
	if timer > fireRate:
		if Input.get_action_raw_strength("shoot") && !dead:
			var temp1 = Bullet.instantiate()
			var temp2 = Bullet.instantiate()
			var temp3 = Bullet.instantiate()
			add_sibling(temp1)
			add_sibling(temp2)
			add_sibling(temp3)
			temp1.set_rotation_degrees(-90)
			temp2.set_rotation_degrees(-90)
			temp3.set_rotation_degrees(-90)
			if Input.get_action_raw_strength("focus") && focus_bar.get_burnout_condition() == false:
				bulletSpawnL.position.x = -40
				bulletSpawnR.position.x = 40
			else:
				bulletSpawnL.position.x = 100
				bulletSpawnR.position.x = -100
			if !(Input.get_action_raw_strength("focus") && focus_bar.get_burnout_condition() == false):
				temp2.set_rotation_degrees(-80)
				temp3.set_rotation_degrees(-100)
				
			temp1.global_position = bulletSpawnM.get("global_position")
			temp2.global_position = bulletSpawnL.get("global_position")
			temp3.global_position = bulletSpawnR.get("global_position")
			timer = 0
