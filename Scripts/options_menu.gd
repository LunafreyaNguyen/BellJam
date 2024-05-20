class_name OptionsMenu
extends Control

@onready var exit_button = $"MarginContainer/VBoxContainer/Exit Button" as Button

signal exit_options_menu

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed()-> void: 
	exit_options_menu.emit()
	SettingsSignalBus.emit_set_settings_dictionary(SettingContainer.create_storage_dictionary())
	set_process(false)

func _process(_delta):
	if Input.is_action_pressed("exit"):
		on_exit_pressed()
