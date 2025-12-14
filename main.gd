extends Node

@export var fish_scene: PackedScene
@export var alert_scene: PackedScene


var total_fish = 0

var fishes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		var screen_size = $Player/Camera2D.get_screen_center_position()
		#var camera_center_position = g
		#var screen_size = get_viewport_rect().size
		# Clamp X position
		print(screen_size)
		$RightAlert.position.x = screen_size.x + 900
		$RightAlert.position.y = 0
		
		$LeftAlert.position.x = screen_size.x + -900
		$LeftAlert.position.y = 0
		#print(alert.position)


func _on_fish_timer_timeout() -> void:
	if(fishes.size() > 10):
		return;
	print(fishes.size())
	var fish = fish_scene.instantiate()
	var fish_spawn_location
	var direction 
	#Pick a Spawn Location
	if(randf() >= 0.5):
		fish_spawn_location = $FishSpawn/FishSpawnLocation
		direction = Vector2.LEFT.normalized()
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

	fishes.push_back(fish)
	$FishLifetimeTimer.start()

func new_game():
	$Player.start($StartPosition.position)
	$FishTimer.start()
	$EndangerFishTimer.start()
	$RightAlert.visible = false
	$LeftAlert.visible = false


	
	

#func _on_fish_lifetime_timer_timeout() -> void:
	#var fish_to_delete = fishes.pop_front()
	#remove_child(fish_to_delete)
	#fish_to_delete.queue_free()
	
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
		
	
