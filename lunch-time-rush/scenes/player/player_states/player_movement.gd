extends State

@export var speed: float = 50
var current_speed

@export var animator : AnimationPlayer


var player: Player
var direction : Vector2

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(_delta : float):
	
#Movement
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
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
	
	if direction:
		player.velocity = direction * current_speed
		player.player_direction = direction
	else:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, speed)
	player.move_and_slide()
	

#Animations
	match direction:
		Vector2.LEFT:
			animator.play("walk_left")
		Vector2.RIGHT:
			animator.play("walk_right")
		Vector2.DOWN:
			animator.play("walk_down")
		Vector2.UP:
			animator.play("walk_up")

#State Transitions
	if direction.length() <= 0:
		state_transition.emit(self, "idle")
	
	if player.tower_in_range && Input.is_action_just_pressed("pick_up"):
		state_transition.emit(self, "pick_up")
	
	if player.has_food || player.pick_up:
		state_transition.emit(self, "pick_up")
