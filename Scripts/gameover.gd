extends Control

var timer = 0
const MAIN_MENU : String = "res://Scenes/main_menu.tscn"
@onready var music = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
