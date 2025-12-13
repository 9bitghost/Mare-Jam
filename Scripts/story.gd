extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$animation.play_backwards("transition_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
