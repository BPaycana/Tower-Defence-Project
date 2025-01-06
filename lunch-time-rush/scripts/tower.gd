extends CharacterBody2D

#var player = CharacterBody2D
#var picked_up = false
#
#@onready var tower_pick_up_range: Area2D = $TowerPickUpRange
#
#func _ready() -> void:
	#player = get_tree().get_first_node_in_group("Player")
	#
#func _physics_process(delta: float) -> void:
	#if picked_up == true:
		#set_collision_layer_value(2, 0)
		#self.position = player.get_node("PickUpPoint").global_position
#
#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("pick_up"):
		#var bodies = tower_pick_up_range.get_overlapping_bodies()
		#for body in bodies:
			#if body.name == "Player":
				#picked_up = true
