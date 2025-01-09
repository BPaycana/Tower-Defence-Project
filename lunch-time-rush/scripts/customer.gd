extends PathFollow2D

@onready var sprites: AnimatedSprite2D = $Sprites

@export var speed = 50
@export var hp = 3

var skin: int

var direction
var anim_finished = true
var food_type = FoodType

func _ready() -> void:
	skin = int(randf_range(1, 3))
	
func _physics_process(delta: float) -> void:
	move(delta)

# Animation
	var old_pos = position
	await(get_tree().create_timer(0.1).timeout)
	direction = position - old_pos
	
	match direction.normalized():
		Vector2.LEFT:
			if anim_finished:
				sprites.play("walk_left" + str(skin))
		Vector2.RIGHT:
			if anim_finished:
				sprites.play("walk_right" + str(skin))
		Vector2.DOWN:
			if anim_finished:
				sprites.play("walk_down" + str(skin))
		Vector2.UP:
			if anim_finished:
				sprites.play("walk_up" + str(skin))

func move(delta):
	set_progress(get_progress() + speed * delta)

func on_hit(_food_type, _damage):
	if _food_type == food_type:
		hp -= _damage
		anim_finished = false
		match direction.normalized():
			Vector2.LEFT:
				sprites.play("hurt_left" + str(skin))
				sprites.animation_finished
			Vector2.RIGHT:
				sprites.play("hurt_right" + str(skin))
				sprites.animation_finished
			Vector2.DOWN:
				sprites.play("hurt_down" + str(skin))
				sprites.animation_finished
			Vector2.UP:
				sprites.play("hurt_up" + str(skin))
				sprites.animation_finished

	if hp <= 0:
		destroy()

func destroy():
	queue_free()

func _on_sprites_animation_finished() -> void:
	anim_finished = true

func set_customer(_food_type: FoodType, _food_amount: int):
	food_type = _food_type
	hp = _food_amount
