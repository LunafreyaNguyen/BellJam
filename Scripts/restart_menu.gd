extends Control

var main : String = "res://Scenes/main_menu.tscn"
@onready var panel_container = $PanelContainer as PanelContainer
@onready var restart_button = $PanelContainer/MarginContainer/VBoxContainer/Restart as Button
@onready var main_menu_button = $PanelContainer/MarginContainer/VBoxContainer/MainMenu as Button
@onready var animation_player = $AnimationPlayer as AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")
	handle_connecting_signals()

func on_restart_pressed() -> void:
	for bullet in get_tree().get_nodes_in_group("EnemyBullet"):
		bullet.queue_free()
	get_tree().reload_current_scene()

func on_main_menu_pressed() -> void:
	for bullet in get_tree().get_nodes_in_group("EnemyBullet"):
		bullet.queue_free()
	get_tree().change_scene_to_file(main)

func handle_connecting_signals() -> void:
	restart_button.button_down.connect(on_restart_pressed)
	main_menu_button.button_down.connect(on_main_menu_pressed)
