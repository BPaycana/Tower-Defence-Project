extends PathFollow2D

@onready var sprites: AnimatedSprite2D = $Sprites

var speed = 50

func _physics_process(delta: float) -> void:
	move(delta)


# Animation
	var old_pos = position
	await(get_tree().create_timer(0.1).timeout)
	var direction = position - old_pos
	print_debug(direction.normalized())
	
	match direction.normalized():
		Vector2.LEFT:
			sprites.play("walk_left")
		Vector2.RIGHT:
			sprites.play("walk_right")
		Vector2.DOWN:
			sprites.play("walk_down")
		Vector2.UP:
			sprites.play("walk_up")

func move(delta):
	set_progress(get_progress() + speed * delta)
