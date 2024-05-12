extends Control

@onready var audio_name_lbl = $"HBoxContainer/Audio Name Lbl" as Label
@onready var audio_num_lbl = $"HBoxContainer/Audio Num Lbl" as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	load_data()
	set_name_label_text()
	set_slider_value()

func set_name_label_text() -> void:
	audio_name_lbl.text = str(bus_name) + " Volume %"

func set_audio_num_label_text() -> void: 
	audio_num_lbl.text = str(h_slider.value * 100)

func get_bus_name_by_index() -> void: 
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value() -> void: 
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num_label_text()

func load_data() -> void: 
	match bus_name:
		"Master": 
			on_value_changed(SettingContainer.get_master_sound())
		"Music": 
			on_value_changed(SettingContainer.get_music_sound())
		"SFX":
			on_value_changed(SettingContainer.get_sfx_sound())

func on_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_audio_num_label_text()
	
	match bus_index: 
		0: #Master
			SettingsSignalBus.emit_on_master_sound_set(value)
		1: #Music
			SettingsSignalBus.emit_on_music_sound_set(value)
		2: #SFX
			SettingsSignalBus.emit_on_sfx_sound_set(value)
