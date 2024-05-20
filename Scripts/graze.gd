extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var styleProgress = get_tree().get_first_node_in_group("Player").styleProgress
@onready var graze = get_tree().get_first_node_in_group("Player").graze
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position



func _on_body_entered(body):
	#if body.is_in_group("EnemyBullet"):
		print(body)
		styleProgress += 1
		graze.play()
