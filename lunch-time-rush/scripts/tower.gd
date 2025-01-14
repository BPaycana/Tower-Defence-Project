extends Area2D

@onready var pivot: Node2D = $Pivot
@onready var sprite: Sprite2D = $Tower
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var food_type: FoodType

var player

var anchor

var enemy_array = []
var enemy

var ready_to_fire = true
var picked_up = false

var damage = 1

var food_amount
@export var food_max: int
var food_min: int = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	food_amount = food_max

func _physics_process(_delta: float) -> void:
	
	if enemy_array.size() != 0:
		select_enemy()
		turn()

		if ready_to_fire && !picked_up && food_amount > 0:
			fire()

	else:
		enemy = null

func turn():
	pivot.look_at(enemy.position)
	
func select_enemy():
	# Selects the enemy that is furthest along the path2d track
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	if enemy.is_satisfied == true:
		enemy_array.erase(enemy)

func fire():
	#Fires food at enemy
	if !picked_up:
		ready_to_fire = false

		const food = preload("res://scenes/food.tscn")
		var new_food = food.instantiate()
		new_food.set_food(food_type, damage)
		new_food.global_position = pivot.get_child(0).global_position
		new_food.global_rotation = pivot.get_child(0).global_rotation
		add_child(new_food)
		food_amount -= 1
		
		animation_player.play("fire")
		
		await get_tree().create_timer(2).timeout
		ready_to_fire = true
		
func change_color():
	if player.tower_in_range:
		sprite.modulate = Color("green")
		
		if picked_up:
			sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 1)

func _on_range_body_entered(body: Node2D) -> void:
	#Adds enemy in area to array
	if body.is_in_group("Customer"):
		if body.get_parent().has_drink == true && body.get_parent().is_satisfied == false && food_type.name == "Drink":
			enemy_array.append(body.get_parent())
		
		if body.get_parent().food_type == food_type && body.get_parent().is_satisfied == false:
			enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	#Removes enemy in area array
	if body.is_in_group("Customer"):

		if body.get_parent().food_type == food_type:
			enemy_array.erase(body.get_parent())
		
		if body.get_parent().has_drink == true:
			enemy_array.erase(body.get_parent())
