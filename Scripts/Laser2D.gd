extends RayCast2D

@onready var line = $Line2D as Line2D
@onready var casting_particle = $CastingParticle
@onready var impact_particle = $ImpactParticle
@onready var beam_particles = $BeamParticles

var is_casting := false : set = set_is_casting

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	line.points[1] = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.get_action_raw_strength("shoot"):
		self.is_casting = true
	else: 
		self.is_casting = false

func _physics_process(delta: float) -> void: 
	var cast_point := target_position
	force_raycast_update()
	
	impact_particle.emitting = is_colliding()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		impact_particle.global_rotation = get_collision_normal().angle()
		impact_particle.position = cast_point
	line.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	beam_particles.emitting = is_casting
	casting_particle.emitting = is_casting
	if is_casting: 
		appear()
	else: 
		impact_particle.emitting = false
		disappear()
	set_physics_process(is_casting)

func appear() -> void: 
	var tween = get_tree().create_tween() as Tween
	tween.tween_property(line, "width", 10.0, 0.2)
	tween.play()

func disappear() -> void: 
	var tween = get_tree().create_tween() as Tween
	tween.tween_property(line, "width", 0, 0.1)
	tween.play()
