extends State

@export var speed: float = 40
@export var animator : AnimationPlayer
@export var pick_up_point : Marker2D

var player: Player
var direction : Vector2

var pick_up_left = Vector2(-6, 0)
var pick_up_right = Vector2(6, 0)
var pick_up_up = Vector2(0, 0)
var pick_up_down = Vector2(0, 1)

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

	if Input.is_action_just_pressed("pick_up"):
		state_transition.emit(self, "movement")
