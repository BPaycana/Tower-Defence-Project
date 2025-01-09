extends State

@export var speed: float = 50
@export var animator : AnimationPlayer


var player: Player
var direction : Vector2

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(delta : float):
	
#Movement
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
	if direction:
		player.velocity = direction * speed
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

	if direction.length() <= 0:
		state_transition.emit(self, "idle")
	
	if player.in_range && Input.is_action_just_pressed("pick_up"):
		state_transition.emit(self, "pick_up")
	
	if player.has_food:
		state_transition.emit(self, "pick_up")
