extends CharacterBody2D

@export var speed = 1000

var screen_size
var level_size

var fishes_on_range = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	print(screen_size.y)
	#level_size = get_viewport_rect().size
	#level_size.x = level_size.x * 2
	#hide()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("mouse_left_click"):
		var fishes_list = fishes_on_range.values()
		for fish in fishes_list:
			fish.set_to_healed()
		fishes_on_range.clear()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
		
	if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	move_and_slide()

		
	
	#position += velocity * delta
	#position.x = clamp(position.x, -screen_size.x, screen_size.x)
	#position.y = clamp(position.y, -screen_size.y/2, screen_size.y/2)

		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "swim"
		$AnimatedSprite2D.flip_v = false
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
			$Area2D/CollisionShapeLeft.disabled = false
			$Area2D/CollisionShapeRight.disabled = true
		else:
			$AnimatedSprite2D.flip_h = false
			$Area2D/CollisionShapeLeft.disabled = true
			$Area2D/CollisionShapeRight.disabled = false
			
		
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "swim"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	var key = str(body.get_instance_id())
	var value = body
	fishes_on_range[key] = value
	
	

	
	# Clamp Y position
	#position.y = clamp(position.y, 0, screen_size.y)

func _on_area_2d_body_exited(body: Node2D) -> void:
	var key = str(body.get_instance_id())
	fishes_on_range.erase(key)
