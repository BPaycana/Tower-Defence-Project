extends State

@export var animator : AnimationPlayer

var player: CharacterBody2D

func Enter():
	print_debug("idle")
	player = get_tree().get_first_node_in_group("Player")
	print_debug(player.direction)
	match player.direction:
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
