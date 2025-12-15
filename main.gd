extends Node

@export var fish_scene: PackedScene
@export var alert_scene: PackedScene

var fishes: Array = []

var lives = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		var screen_size = $Player/Camera2D.get_screen_center_position()
		#var camera_center_position = g
		#var screen_size = get_viewport_rect().size
		# Clamp X position
		$RightAlert.position.x = screen_size.x + 900
		$RightAlert.position.y = 0
		
		$LeftAlert.position.x = screen_size.x + -900
		$LeftAlert.position.y = 0
		
		$GameOver.position.x = screen_size.x
		$GameOver.position.y= -100
		
		$LifeCounter.position.x = screen_size.x + 860
		$LifeCounter.position.y = -600
		$LifeCounter/Label.text = 'Vidas: %d' %lives
		

func _on_fish_timer_timeout() -> void:
	if(fishes.size() > 10):
		return;
		
	var fish = fish_scene.instantiate()
	var fish_spawn_location
	var direction 
	#Pick a Spawn Location
	if(randf() >= 0.5):
		fish_spawn_location = $FishSpawn/FishSpawnLocation
		direction = Vector2.LEFT.normalized()
		var sprite_node = fish.get_node("AnimatedSprite2D")
		sprite_node.flip_v = true
		
	else:
		fish_spawn_location = $FishSpawn2/FishSpawnLocation2
		direction = Vector2.RIGHT.normalized()

	# Choose a random location on Path2D.
	fish_spawn_location.progress_ratio = randf()

	fish.position = fish_spawn_location.position
	fish.rotation = fish_spawn_location.rotation + PI / 2
	fish.direction = direction
	
	add_child(fish)
	
	fish.alert_offscreen.connect(_on_fish_offscreen)
	fish.alert_onscreen.connect(_on_fish_onscreen)
	fish.kill_fish.connect(_on_kill_fish)

	fishes.push_back(fish)
	$FishLifetimeTimer.start()

func new_game():
	var screen_size = $Player/Camera2D.get_screen_center_position()
	$LifeCounter.position.x = screen_size.x + 860
	$LifeCounter.position.y = -600
	$LifeCounter/Label.text = 'Vidas: %d' %lives
	$Player.start($StartPosition.position)
	$FishTimer.start()
	$EndangerFishTimer.start()
	$RightAlert.visible = false
	$LeftAlert.visible = false
	$LevelMusic.play()
	
	
func _on_fish_offscreen(position: Vector2) -> void:
		var screen_center_position = $Player/Camera2D.get_screen_center_position()
		if position.x > screen_center_position.x:
			$RightAlert.visible = true
		else:
			$LeftAlert.visible = true
			
func _on_fish_onscreen(position: Vector2) -> void:
		var screen_center_position = $Player/Camera2D.get_screen_center_position()
		if position.x > screen_center_position.x:
			$RightAlert.visible = false
		else:
			$LeftAlert.visible = false
			
func _on_kill_fish(fish: Fish) -> void:
	var fish_instance_id = fish.get_instance_id()
	var index_to_remove = -1
	for i in fishes.size():
		if(fishes[i].get_instance_id() == fish_instance_id):
			index_to_remove = i
	if(index_to_remove >= 0):
		$FishDeathSFX2D.play()
		fishes.remove_at(index_to_remove)
		remove_child(fish)
		fish.queue_free()
		if (lives > 0):
			lives = lives - 1
		if (lives == 0):
			#$LevelMusic.stop()
			$GameOverMusic.play()
			$GameOver.visible = true
			get_tree().paused = true
	

func _on_endanger_fish_timer_timeout() -> void:
	var non_immune_fishes = fishes.filter(func(fish): return fish.immune == false && fish.endangered == false)
	if(!non_immune_fishes.is_empty()):
		non_immune_fishes.pick_random().set_to_endangered()	

func _on_play_area_body_exited(body: Node2D) -> void:
	if body is Fish:
			var fish_instance_id = body.get_instance_id()
			var index_to_remove = -1
			for i in fishes.size():
				if(fishes[i].get_instance_id() == fish_instance_id):
					index_to_remove = i
			if(index_to_remove >= 0):
				fishes.remove_at(index_to_remove)
				remove_child(body)
				body.queue_free()
		
	
