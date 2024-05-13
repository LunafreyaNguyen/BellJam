extends Control

@export var increment : int = 10
@export var decrement : int = 5

@onready var bar = $TextureProgressBar
@onready var burnout_timer = $BurnoutTimer

var burnout_condition : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_value(value : int) -> void:
	bar.value = bar.value + value
	if(bar.value == bar.max_value):
		#print("I'M MAXING")
		burnout()

func decrease_value(value : int) -> void:
	if bar.value < value:
		bar.value = bar.min_value
	bar.value = bar.value - value

func burnout():
	burnout_condition = true
	burnout_timer.start()

func _on_burnout_timer_timeout():
	#print("I'M TIMING!")
	if(bar.value == bar.min_value):
		#print("Timing over orz...")
		burnout_timer.stop()
		burnout_condition = false
		return
	decrease_value(25)

func get_burnout_condition():
	return burnout_condition
