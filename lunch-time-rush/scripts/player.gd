extends CharacterBody2D

@export var speed: float = 50

var direction : Vector2


func _physics_process(delta: float) -> void:
	
	#Movement
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
	#if direction.x > 0: %sprite.flip_h = false
	#elif direction.x < 0: %sprite.flip_h = true
	
	if direction:
		velocity = direction * speed
		#if %sprite.animation != "walking": %sprite.animation = "walking"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		#if %sprite.animation != "idle": %sprite.animation = "idle"
	move_and_slide()
