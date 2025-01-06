class_name Player
extends CharacterBody2D

@onready var pick_up_point: Marker2D = $PickUpPoint
@onready var pick_up_range: Area2D = $PickUpRange

var player_direction : Vector2
var pick_up = false
var tower


#func _ready() -> void:
	#animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(delta: float) -> void:
	
#	Pick up tower
	if  !pick_up && pick_up_range.has_overlapping_areas() && tower != null && Input.is_action_just_pressed("pick_up"):
		
		tower.call_deferred("reparent", self.pick_up_point)
		tower.position = pick_up_point.global_position
		
		await get_tree().create_timer(0.1).timeout
		pick_up = true

#	Drop down tower
	if pick_up && Input.is_action_just_pressed("pick_up"):
		tower.call_deferred("reparent", self.get_parent())
		
		await get_tree().create_timer(0.1).timeout
		pick_up = false
	


func _on_pick_up_range_area_entered(area: Area2D) -> void:
	if !pick_up && area.is_in_group("Towers"):
		tower = area
