extends PathFollow2D

@onready var sprites: AnimatedSprite2D = $Sprites
@onready var emotes: AnimatedSprite2D = $Emotes

@export var speed = 50
@export var hp: int = 3

@export var food_amount: RichTextLabel
@export var container: VBoxContainer

@onready var sfx_eating: AudioStreamPlayer = $SFXEating
@onready var sfx_full: AudioStreamPlayer = $SFXFull


const BURGER = preload("res://scenes/ui/food_bubble/burger_gui.tscn")
const FRIES = preload("res://scenes/ui/food_bubble/fries_gui.tscn")
const DRINK = preload("res://scenes/ui/food_bubble/drink_gui.tscn")

var text_effect: String = "[color=black][wave amp=10.0 freq=10.0 connected=1] "

var skin: int

var direction
var rounded_direction
var anim_finished = true
var is_hurt = false      # Tracks if the customer is in a hurt state

var food_type = FoodType
var has_drink = false

var is_satisfied = false

var level

func _ready() -> void:
	direction = position
	level = get_parent().get_parent()
	add_food_to_container()
	food_amount.text = text_effect + str(hp)
	skin = int(randf_range(1, 3))
	
func _physics_process(delta: float) -> void:

		
	move(delta)
	if progress_ratio >= 1:
		delete()

func move(delta):
	
	set_progress(get_progress() + speed * delta)
	
	var old_pos = position
	await(get_tree().create_timer(0.1).timeout)
	direction = position - old_pos
	rounded_direction = round_direction(direction)
	update_animation(rounded_direction)
	
	
	#match rounded_direction:
		#Vector2.LEFT:
			#if anim_finished:
				#sprites.play("walk_left" + str(skin))
		#Vector2.RIGHT:
			#if anim_finished:
				#sprites.play("walk_right" + str(skin))
		#Vector2.DOWN:
			#if anim_finished:
				#sprites.play("walk_down" + str(skin))
		#Vector2.UP:
			#if anim_finished:
				#sprites.play("walk_up" + str(skin))
		#Vector2.DOWN + Vector2.LEFT:
			#if anim_finished:
				#sprites.play("walk_down" + str(skin))
		#Vector2.DOWN + Vector2.RIGHT:
			#if anim_finished:
				#sprites.play("walk_down" + str(skin))
		#Vector2.UP + Vector2.LEFT:
			#if anim_finished:
				#sprites.play("walk_up" + str(skin))
		#Vector2.UP + Vector2.RIGHT:
			#if anim_finished:
				#sprites.play("walk_up" + str(skin))

func round_direction(_direction: Vector2) -> Vector2:
	var x = direction.x
	var y = direction.y

	return Vector2(1 if x > 0 else -1 if x < 0 else 0, 1 if y > 0 else -1 if y < 0 else 0)

func update_animation(_direction: Vector2):
	
	if is_hurt: 
		return # Skip updating walk animations if in the hurt state

	match _direction:
		Vector2.LEFT:
			sprites.play("walk_left" + str(skin))
		Vector2.RIGHT:
			sprites.play("walk_right" + str(skin))
		Vector2.UP:
			sprites.play("walk_up" + str(skin))
		Vector2.DOWN:
			sprites.play("walk_down" + str(skin))
			
		#Vector2.DOWN + Vector2.LEFT, Vector2.DOWN + Vector2.RIGHT:
			#sprites.play("walk_down" + str(skin))
		#Vector2.UP + Vector2.RIGHT, Vector2.UP + Vector2.RIGHT:
			#sprites.play("walk_up" + str(skin))

func on_hit(_food_type, _damage):
	if !is_satisfied:
		if _food_type == food_type:
			hp -= _damage
			food_amount.text = text_effect + str(hp)
			hurt_anim()
		
		if _food_type.name == "Drink":
			if has_drink:
				hp -= _damage
				food_amount.text = text_effect + str(hp)
				hurt_anim()
		
		if hp > 0:
			sfx_eating.play()

		if hp <= 0:
			satisfied()

func satisfied():
	is_satisfied = true
	
	#Change visibility of bubbles
	container.get_parent().set_visible(false)
	emotes.set_visible(true)
	emotes.play("satisfied")
	sfx_full.play()

	speed = speed * 5

func delete():
	level.customers_in_wave -= 1
	level.tv.get_child(0).text = "[color=gray][wave amp=10.0 freq=10.0 connected=1]" + " x " + str(level.customers_in_wave)
	
	if level.customers_in_wave <= 0:
		level.wave_number += 1
		
		if level.wave_number < level.level_data.wave.size():
			level.button.set_visible(true)
			
	if !is_satisfied:
		level.customer_unsatisfied()
	queue_free()

func hurt_anim():
	is_hurt = true
	anim_finished = false

	match rounded_direction.normalized():
		Vector2.LEFT:
			sprites.play("hurt_left" + str(skin))
			
		Vector2.RIGHT:
			sprites.play("hurt_right" + str(skin))
			
		Vector2.DOWN:
			sprites.play("hurt_down" + str(skin))
			
		Vector2.UP:
			sprites.play("hurt_up" + str(skin))
			
		Vector2.DOWN + Vector2.LEFT:
			sprites.play("hurt_down" + str(skin))
			
		Vector2.DOWN + Vector2.RIGHT:
			sprites.play("hurt_down" + str(skin))
			
		Vector2.UP + Vector2.LEFT:
			sprites.play("hurt_up" + str(skin))
			
		Vector2.UP + Vector2.RIGHT:
			sprites.play("hurt_up" + str(skin))
			

	await sprites.animation_finished
	anim_finished = true
	is_hurt = false
	
	# Resume walking animation based on the last direction
	update_animation(rounded_direction)

func add_food_to_container():
	if food_type == null:
		return

	match food_type.name:
		"Burger": 
			var burger = BURGER.instantiate()
			container.add_child(burger)
		
		"Fries":
			var fries = FRIES.instantiate()
			container.add_child(fries)

	if has_drink:
		var drink = DRINK.instantiate()
		container.add_child(drink)

func set_customer(_food_type: FoodType, _food_amount: int, _has_drink: bool):
	food_type = _food_type
	hp = _food_amount
	has_drink = _has_drink
