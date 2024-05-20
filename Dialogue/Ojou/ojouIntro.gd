extends BaseDialogueTestScene

@export var dialogue_resource: DialogueResource
#Title must match Resource file Title
@export var dialogue_title : String = "start"
@onready var ost = $AudioStreamPlayer
@onready var balloon = load("res://Dialogue/Ojou/balloon.tscn").instantiate()

func _ready() -> void:
	ost.play()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_title)

func _physics_process(_delta):
	if Input.get_action_strength("pause") || balloon == null:
		get_tree().change_scene_to_file("res://Scenes/levels/testLuna.tscn")
