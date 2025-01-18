extends State

@export var speed: float = 40
var current_speed
@export var animator : AnimationPlayer
@export var pick_up_point : Marker2D

var player: Player
var direction : Vector2


var pick_up_left = Vector2(-6, 0)
var pick_up_right = Vector2(6, 0)
var pick_up_up = Vector2(0, -1)
var pick_up_down = Vector2(0, 1)

func Enter():
	# Assigns player
	player = get_tree().get_first_node_in_group("Player")
	pick_up_animation()


func Update(_delta : float):
	
	if not player.anim_finished:
		return

	if Input.is_action_pressed("sprint") && player.stamina > 0:
		current_speed = player.sprint(speed)
		player.stamina -= player.stamina_drain * _delta
		player.stamina_bar.value = player.stamina
		player.stamina_bar.set_visible(true)
	else:
		current_speed = speed
		player.dust.set_visible(false)
		player.stamina_bar.set_visible(false)
		if player.stamina < player.max_stamina:
			player.stamina += player.stamina_drain / 2 * _delta

#Movement
	if player.anim_finished:
		direction.x = Input.get_axis("left","right")
		direction.y = Input.get_axis("up","down")
		
		if direction:
			player.velocity = direction * current_speed
			player.player_direction = direction
			player.move_and_slide()
		else:
			player.velocity = player.velocity.move_toward(Vector2.ZERO, speed)
	
	pick_up_movement_animation()
	

	if !player.has_food && !player.pick_up:
		await get_tree().create_timer(0.1).timeout
		state_transition.emit(self, "movement")
	

func pick_up_animation():

	#Plays pick up animation
	pick_up_point.position = pick_up_up
	player.anim_finished = false
	animator.play("grab_object_up", -1, 2.0)
	await animator.animation_finished
	player.anim_finished = true

func pick_up_movement_animation():
	#Animations
	match direction:
		Vector2.LEFT:
			animator.play("walk_with_object_left")
			pick_up_point.position = pick_up_left
		Vector2.RIGHT:
			animator.play("walk_with_object_right")
			pick_up_point.position = pick_up_right
		Vector2.DOWN:
			animator.play("walk_with_object_down")
			pick_up_point.position = pick_up_down
		Vector2.UP:
			animator.play("walk_with_object_up")
			pick_up_point.position = pick_up_up
		Vector2.DOWN + Vector2.LEFT:
			animator.play("walk_with_object_down")
			pick_up_point.position = pick_up_down
		Vector2.DOWN + Vector2.RIGHT:
			animator.play("walk_with_object_down")
			pick_up_point.position = pick_up_down
		Vector2.UP + Vector2.LEFT:
			animator.play("walk_with_object_up")
			pick_up_point.position = pick_up_up
		Vector2.UP + Vector2.RIGHT:
			animator.play("walk_with_object_up")
			pick_up_point.position = pick_up_up
