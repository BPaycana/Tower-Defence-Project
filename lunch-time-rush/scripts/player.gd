class_name Player
extends CharacterBody2D

@onready var pick_up_point: Marker2D = $PickUpPoint
@onready var pick_up_range: Area2D = $PickUpRange
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dust: AnimatedSprite2D = $Dust

@onready var box: Sprite2D = $PickUpPoint/Box
@onready var stamina_bar: TextureProgressBar = $FoodBar

@onready var sfx_drop_tower: AudioStreamPlayer = $SFXDropTower

var max_stamina = 100
var stamina = 100
var stamina_drain = 100

var player_direction : Vector2
var pick_up = false
var tower_in_range = false
var anchor_in_range = false
var has_food = false

var tower
var anchor
var anim_finished = true

func _physics_process(_delta: float) -> void:
	stamina_bar.value = stamina
#	Pick up tower
	if  !pick_up && tower_in_range && tower != null && Input.is_action_just_pressed("pick_up") && !has_food:
		_pick_up(tower)
		tower.picked_up = true

#	Refill tower
	if !pick_up && tower_in_range && tower != null && Input.is_action_just_pressed("pick_up") && has_food:
		refill(tower)

#	Drop down tower
	if pick_up && Input.is_action_just_pressed("pick_up") && anchor_in_range:
		_put_down(tower)
		tower.picked_up = false

func _pick_up(_pick_up_tower):
	#Reparents the tower and sets its position on the player
	tower.call_deferred("reparent", self.pick_up_point)
	tower.position = pick_up_point.global_position
	
	#Checks if the tower has an anchor already
	if tower.anchor != null:
		tower.anchor.occupied = false
		tower.anchor = null
	
	await get_tree().create_timer(0.1).timeout
	pick_up = true

func _put_down(_put_down_tower):
	#Unparents the tower
	tower.call_deferred("reparent", self.get_parent())
	
	#Sets position to the anchor
	tower.global_position = Vector2(anchor.global_position.x, anchor.global_position.y - 10)
	
	#Assigns the tower an anchor
	tower.anchor = anchor
	anchor.occupied = true
	
	sfx_drop_tower.play()
	
	await get_tree().create_timer(0.1).timeout
	pick_up = false

func _pick_up_food():
	if !tower_in_range:
		box.set_visible(true)
		has_food = true

func refill(_refill_tower):
	#Refills the tower's food amount
	tower.food_amount = tower.food_max
	box.set_visible(false)
	has_food = false
	pick_up = false

func sprint(speed):
	dust.set_visible(true)
	dust.play()
	speed = speed * 2
	return speed

func _on_pick_up_range_area_entered(area: Area2D) -> void:
	if !pick_up && area.is_in_group("Towers"):
		tower_in_range = true
		tower = area
		tower.change_color()
	
	if area.is_in_group("Anchor"):
		if !area.occupied:
			anchor_in_range = true
			anchor = area
		

func _on_pick_up_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("Towers"):
		tower_in_range = false
		tower.change_color()
	
	if area.is_in_group("Anchor"):
		anchor_in_range = false
