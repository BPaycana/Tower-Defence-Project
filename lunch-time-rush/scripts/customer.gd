extends PathFollow2D

@onready var sprites: AnimatedSprite2D = $Sprites

@export var speed = 50
@export var hp = 3

func _physics_process(delta: float) -> void:
	move(delta)

# Animation
	var old_pos = position
	await(get_tree().create_timer(0.1).timeout)
	var direction = position - old_pos
	
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

func on_hit(damage):
	hp -= damage
	print_debug(hp)
	if hp <= 0:
		destroy()

func destroy():
	queue_free()
