extends State

@export var animator : AnimationPlayer

var player: Player

func Enter():
	print_debug("idle")
	player = get_tree().get_first_node_in_group("Player")

# Animation
	match player.player_direction:
		Vector2.LEFT:
			animator.play("idle_left")
		Vector2.RIGHT:
			animator.play("idle_right")
		Vector2.DOWN:
			animator.play("idle_down")
		Vector2.UP:
			animator.play("idle_up")
	

func Update(_delta:float):
	
	if(Input.get_vector("left","right","up","down").normalized()):
		state_transition.emit(self, "movement")

	if Input.is_action_just_pressed("pick_up"):
		state_transition.emit(self, "pick_up")
