class_name MainMenu
extends Control

@onready var start_button = $"MarginContainer/HBoxContainer/VBoxContainer/Buttons/VBoxContainer/Start Button" as Button
@onready var options_button = $"MarginContainer/HBoxContainer/VBoxContainer/Buttons/VBoxContainer/Options Button" as Button
@onready var quit_button = $"MarginContainer/HBoxContainer/VBoxContainer/Buttons/VBoxContainer/Quit Button" as Button
@onready var options_menu = $"Options Menu" as OptionsMenu
@onready var margin_container = $"MarginContainer" as MarginContainer
@onready var bg = $BG

@export var start_level = preload("res://Scenes/testLuna.tscn") as PackedScene
#change this to main.tscn for final build

func _ready():
	handle_connecting_signals()

func on_start_pressed() -> void: 
	bg.texture = load("res://Art/Backgrounds/titlescreenred_notext.jpg")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(start_level)
	

func on_quit_pressed() -> void:
	get_tree().quit()

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	

func on_exit_options_menu() -> void: 
	margin_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	quit_button.button_down.connect(on_quit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
