extends Area2D

@onready var pivot: Node2D = $Pivot
@onready var sprite: Sprite2D = $Tower
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var food_type: FoodType

@onready var drop_tower_sfx: AudioStreamPlayer = $DropTowerSFX

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

# Throw arc variables
var initial_speed: float = 300
var throw_angle_degrees: float = 45
var time: float = 0.0
var initial_position: Vector2
var throw_direction: Vector2
var is_throwing: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	food_amount = food_max

func _physics_process(delta: float) -> void:
	if is_throwing:
		time += delta

		# Simulate the throw arc
		var z_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)

		if z_axis >= 0:
			# Calculate horizontal movement
			var x_axis = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			var current_position = initial_position + throw_direction * x_axis

			# Update tower's position
			global_position = Vector2(current_position.x, current_position.y - z_axis)
		else:
			# Reset state when tower lands
			is_throwing = false
			land()

	if enemy_array.size() != 0 and !picked_up and !is_throwing:
		select_enemy()
		turn()

		if !anchor == null and ready_to_fire and food_amount > 0:
			fire()
	else:
		enemy = null

func launch(direction: Vector2, speed: float, angle: float) -> void:
	# Initiate the throw
	initial_position = global_position
	throw_direction = direction.normalized()
	initial_speed = speed
	throw_angle_degrees = angle

	time = 0.0
	is_throwing = true

func land():
	# Called when the tower lands
	 # Reset firing state
	drop_tower_sfx.play()

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
	if enemy.is_satisfied:
		enemy_array.erase(enemy)

func fire():
	# Fires food at enemy
	if !picked_up:
		ready_to_fire = false

		const food = preload("res://scenes/towers/food.tscn")
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
	# Adds enemy in area to array
	if body.is_in_group("Customer"):
		if body.get_parent().has_drink == true and body.get_parent().is_satisfied == false and food_type.name == "Drink":
			enemy_array.append(body.get_parent())

		if body.get_parent().food_type == food_type and body.get_parent().is_satisfied == false:
			enemy_array.append(body.get_parent())
	
	if body.is_in_group("Walls"):
		
		is_throwing = false
		land()

func _on_range_body_exited(body: Node2D) -> void:
	# Removes enemy in area array
	if body.is_in_group("Customer"):
		if body.get_parent().food_type == food_type:
			enemy_array.erase(body.get_parent())

		if body.get_parent().has_drink == true:
			enemy_array.erase(body.get_parent())


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		is_throwing = false
		land()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Anchor"):
		if area.occupied == false && is_throwing:
			is_throwing = false
			land()
			global_position = Vector2(area.global_position.x, area.global_position.y - 10)
			anchor = area
			area.occupied = true
