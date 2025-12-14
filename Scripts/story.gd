extends Control

var canContinue: bool = false
var clickScreen: bool = false
var gameBegin: bool = false

func _ready() -> void:
	$blackscreenAnim.play_backwards("transition_out")

func _process(delta: float) -> void:
	if clickScreen:
		canContinue = false
		clickScreen = false
		$Control/textAnimation.play("second_type")
		$panels/panelsAnim.play("second")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event.is_action_pressed("ui_accept"):
		if gameBegin:
			get_tree().change_scene_to_file("res://Scenes/instrucoes.tscn")
		elif canContinue:
			clickScreen = true
			$Arrow/arrowAnim.stop()

func _on_blackscreen_anim_animation_finished(anim_name: StringName) -> void:
	$Control/textAnimation.play("first_type")
	$panels/panelsAnim.play("first")
	
func _on_text_animation_animation_finished(anim_name: StringName) -> void:
	$Arrow/arrowAnim.play("blink")
	canContinue = true
	if anim_name == "second_type":
		gameBegin = true
