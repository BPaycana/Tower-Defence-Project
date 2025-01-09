class_name Player
extends CharacterBody2D

@onready var pick_up_point: Marker2D = $PickUpPoint
@onready var pick_up_range: Area2D = $PickUpRange

@onready var box: Sprite2D = $PickUpPoint/Box

var player_direction : Vector2
var pick_up = false
var in_range = false
var has_food = false
var food_box
var tower



#func _ready() -> void:
	#animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(delta: float) -> void:
	
#	Pick up tower
	if  !pick_up && in_range && tower != null && Input.is_action_just_pressed("pick_up") && !has_food:
		_pick_up(tower)
		tower.picked_up = true

#	Refill tower
	if !pick_up && in_range && tower != null && Input.is_action_just_pressed("pick_up") && has_food:
		refill(tower)

#	Drop down tower
	if pick_up && Input.is_action_just_pressed("pick_up"):
		_put_down(tower)
		tower.picked_up = false

func _pick_up(tower):
	#Reparents the tower and sets its position on the player
	tower.call_deferred("reparent", self.pick_up_point)
	tower.position = pick_up_point.global_position
	
	await get_tree().create_timer(0.1).timeout
	pick_up = true

func _pick_up_food():
	box.set_visible(true)
	has_food = true
	

func _put_down(tower):
	#Unparents the tower
	tower.call_deferred("reparent", self.get_parent())

	await get_tree().create_timer(0.1).timeout
	pick_up = false

func refill(tower):
	#Refills the tower's food amount
	tower.food_amount = tower.food_max
	box.set_visible(false)
	has_food = false
	pick_up = false


func _on_pick_up_range_area_entered(area: Area2D) -> void:
	if !pick_up && area.is_in_group("Towers"):
		in_range = true
		tower = area

func _on_pick_up_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("Towers"):
		in_range = false
