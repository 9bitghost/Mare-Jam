class_name Fish extends RigidBody2D

@export var base_speed: float = 100.0
@export var speed_amplitude: float = 50.0
@export var oscillation_frequency: float = 2.0 # How many cycles per second
@export var direction: Vector2 = Vector2.RIGHT.normalized()

signal alert_offscreen(fish_position: Vector2)
signal alert_onscreen(fish_position: Vector2)
signal kill_fish(fish: Fish)

 
var endangered = false
var immune = true
var fish_types = ["fish", "dolphin"]
var instance_fish_type

var time_elapsed: float = 0.0
func _ready() -> void:
	
	instance_fish_type = fish_types.pick_random()
	var animation = "swim" if instance_fish_type == "fish" else "dolphin_swim"
	$AnimatedSprite2D.play(animation)
	if instance_fish_type == "dolphin":
		$CollisionShape2DFish.disabled = true
		$CollisionShape2DDoplhin.disabled = false
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
	var animation = "swim_endangered" if instance_fish_type == "fish" else "dolphin_swim_endangered"	
	$AnimatedSprite2D.play(animation)
	$FishDeathTimer.start()
	

	
func set_to_healed() -> void:
	if (endangered == true):
		$FishDeathTimer.stop()
		endangered = false
		immune = true
		var animation = "swim" if instance_fish_type == "fish" else "dolphin_swim"
		$CleanFishSFX2D.play()
		$AnimatedSprite2D.play(animation)
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


func _on_fish_death_timer_timeout() -> void:
	kill_fish.emit(self)
