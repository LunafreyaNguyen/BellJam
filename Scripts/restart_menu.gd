extends Control

var main : String = "res://Scenes/main_menu.tscn"
@onready var panel_container = $PanelContainer as PanelContainer
@onready var restart_button = $PanelContainer/MarginContainer/VBoxContainer/Restart as Button
@onready var main_menu_button = $PanelContainer/MarginContainer/VBoxContainer/MainMenu as Button
@onready var animation_player = $AnimationPlayer as AnimationPlayer

var _is_paused : bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")
	handle_connecting_signals()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused

func resume() -> void:
	_is_paused = false
	animation_player.play_backwards("blur")

func pause() -> void: 
	_is_paused = true
	animation_player.play("blur")

func on_restart_pressed() -> void:
	pass

func on_main_menu_pressed() -> void:
	for bullet in get_tree().get_nodes_in_group("EnemyBullet"):
		bullet.queue_free()
	resume()
	get_tree().change_scene_to_file(main)

func handle_connecting_signals() -> void:
	restart_button.button_down.connect(on_restart_pressed)
	main_menu_button.button_down.connect(on_main_menu_pressed)
