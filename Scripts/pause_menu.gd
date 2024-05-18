extends Control

var main : String = "res://Scenes/main_menu.tscn"
@onready var panel_container = $PanelContainer as PanelContainer
@onready var options_menu = $"Options Menu" as OptionsMenu
@onready var resume_button = $PanelContainer/MarginContainer/VBoxContainer/Resume as Button
@onready var options_button = $PanelContainer/MarginContainer/VBoxContainer/Options as Button
@onready var main_menu_button = $PanelContainer/MarginContainer/VBoxContainer/MainMenu as Button
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("Player")

var _is_paused : bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		if _is_paused:
			Engine.time_scale = 0.0
		else: 
			Engine.time_scale = 1.0
		visible = _is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")
	handle_connecting_signals()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") && !player.isDead():
		#print("pause captured")
		_is_paused = !_is_paused

func resume() -> void:
	#print("resuming")
	_is_paused = false
	animation_player.play_backwards("blur")

func pause() -> void: 
	_is_paused = true
	animation_player.play("blur")

func on_options_pressed() -> void:
	panel_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_main_menu_pressed() -> void:
	for bullet in get_tree().get_nodes_in_group("EnemyBullet"):
		bullet.queue_free()
	resume()
	get_tree().change_scene_to_file(main)

func on_exit_options_menu() -> void: 
	panel_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	resume_button.button_down.connect(resume)
	options_button.button_down.connect(on_options_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	main_menu_button.button_down.connect(on_main_menu_pressed)


