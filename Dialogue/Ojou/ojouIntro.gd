extends BaseDialogueTestScene

@export var dialogue_resource : DialogueResource
#Title must match Resource file Title
@export var dialogue_title : String = "start"
@onready var ost = $AudioStreamPlayer

func _ready() -> void:
	ost.play()
	var balloon = load("res://Dialogue/Ojou/balloon.tscn").instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_title)
