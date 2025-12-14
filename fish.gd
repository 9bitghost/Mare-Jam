class_name Fish extends RigidBody2D

@export var base_speed: float = 100.0
@export var speed_amplitude: float = 50.0
@export var oscillation_frequency: float = 2.0 # How many cycles per second
@export var direction: Vector2 = Vector2.RIGHT.normalized()

signal alert_offscreen(fish_position: Vector2)
signal alert_onscreen(fish_position: Vector2)

 
var endangered = false
var immune = true

var time_elapsed: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var mob_types = Array($AnimatedSprite2D.sprite_frames.get
	$AnimatedSprite2D.animation = "swim"
	$AnimatedSprite2D.play()
	$RemoveImmunityTimer.start()

func _integrate_forces(state):
	if(endangered == true):
		base_speed = 40.0
	else:
		base_speed = 100.0
	time_elapsed += state.step # state.step is the delta time for the physics engine
	var current_speed = base_speed + speed_amplitude * sin(time_elapsed * oscillation_frequency * 2.0 * PI)
	state.linear_velocity = direction * current_speed
	
func set_to_endangered() -> void:
	endangered = true
	$AnimatedSprite2D.animation = "swim_endangered"
	$AnimatedSprite2D.play()

	
func set_to_healed() -> void:
	endangered = false
	immune = true
	$AnimatedSprite2D.animation = "swim"
	$AnimatedSprite2D.play()
	$RemoveImmunityTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if endangered == true:
		if $VisibleOnScreenNotifier2D.is_on_screen():
			alert_onscreen.emit(position)
		else:
			alert_offscreen.emit(position)


func _on_remove_immunity_timer_timeout() -> void:
	immune = false # Replace with function body.
