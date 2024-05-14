extends Control

@onready var option_button = $HBoxContainer/OptionButton

const RESOLUTION_DICTIONARY: Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1366 x 768" : Vector2i(1366, 768),
	"1920 x 1080" : Vector2i(1920, 1080),
	"2560 x 1440" : Vector2i(2560, 1440),
	"3456 x 2234" : Vector2i(3456, 2234)
}


func _ready():
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_items()
	load_data()

func load_data() -> void: 
	on_resolution_selected(SettingContainer.get_resolution_index())
	option_button.select(SettingContainer.get_resolution_index())

func add_resolution_items() -> void: 
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)

func on_resolution_selected(index : int) -> void: 
	SettingsSignalBus.emit_on_resolution_selected(index)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
