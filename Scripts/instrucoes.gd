extends Control

var gameStart = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		IntroMusic.stop()
		$blackscreenAnim.play("transition_out")
		await $blackscreenAnim.animation_finished
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
