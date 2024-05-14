extends Node2D
var timer = 0
const MAIN_MENU : String = "res://Scenes/main_menu.tscn"
@onready var music = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > 7:
		get_tree().change_scene_to_file(MAIN_MENU)
