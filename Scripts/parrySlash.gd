extends Node2D
@onready var parryImage = $parryImage
@onready var success = $success


# Called when the node enters the scene tree for the first time.
func _ready():
	parryImage.visible = false


func parry():
	parryImage.visible = true
	modulate.a = 1
	success.play()
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, .5).from(1)
	Engine.time_scale = .3
	var timeTween: Tween = create_tween()
	await get_tree().create_timer(.8, true, false, true).timeout
	Engine.time_scale = 1
