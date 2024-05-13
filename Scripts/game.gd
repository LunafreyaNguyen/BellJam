extends Node2D
@onready var Camera = get_node("Camera2D")
@onready var audio_stream_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
