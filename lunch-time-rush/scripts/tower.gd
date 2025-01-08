extends Area2D

@onready var pivot: Node2D = $Pivot
@export var food_type: FoodType

var enemy_array = []
var enemy
var ready_to_fire = true
var damage = 1

func _ready() -> void:
	print_debug(food_type.name)

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		if ready_to_fire:
			fire()
	else:
		enemy = null

func turn():
	pivot.look_at(enemy.position)
	
func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire():
	ready_to_fire = false
	const food = preload("res://scenes/food.tscn")
	var new_food = food.instantiate()
	new_food.set_food(food_type, damage)
	new_food.global_position = pivot.get_child(0).global_position
	new_food.global_rotation = pivot.get_child(0).global_rotation
	add_child(new_food)
	
	await get_tree().create_timer(2).timeout
	ready_to_fire = true

func _on_range_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Customer"):
		if body.get_parent().food_type == food_type:
			enemy_array.append(body.get_parent())
			print(enemy_array)

func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Customer"):
		if body.get_parent().food_type == food_type:
			enemy_array.erase(body.get_parent())
