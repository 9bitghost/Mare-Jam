extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()
	
func continuar():
	get_tree().paused = false
	
func pausar():
	get_tree().paused = true
	
func testEsc():
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused:
			pausar()
		else:
			continuar()

func _on_continuar_pressed() -> void:
	continuar()

func _on_recomeçar_pressed() -> void:
	continuar()
	get_tree().reload_current_scene()

func _on_sair_pressed() -> void:
	get_tree().quit()
