extends PathFollow2D

@onready var sprites: AnimatedSprite2D = $Sprites
@onready var emotes: AnimatedSprite2D = $Emotes

@export var speed = 50
@export var hp: int = 3

@export var food_amount: RichTextLabel
@export var container: VBoxContainer

const BURGER = preload("res://scenes/ui/burger_gui.tscn")
const FRIES = preload("res://scenes/ui/fries_gui.tscn")
const DRINK = preload("res://scenes/ui/drink_gui.tscn")

var text_effect: String = "[color=black][wave amp=10.0 freq=10.0 connected=1] "

var skin: int

var direction
var anim_finished = true

var food_type = FoodType
var has_drink = false

var is_satisfied = false

func _ready() -> void:
	add_food_to_container()
	food_amount.text = text_effect + str(hp)
	skin = int(randf_range(1, 3))
	
func _physics_process(delta: float) -> void:
	move(delta)

# Animation
	var old_pos = position
	await(get_tree().create_timer(0.1).timeout)
	direction = position - old_pos
	
	match direction.normalized():
		Vector2.LEFT:
			if anim_finished:
				sprites.play("walk_left" + str(skin))
		Vector2.RIGHT:
			if anim_finished:
				sprites.play("walk_right" + str(skin))
		Vector2.DOWN:
			if anim_finished:
				sprites.play("walk_down" + str(skin))
		Vector2.UP:
			if anim_finished:
				sprites.play("walk_up" + str(skin))

func move(delta):
	set_progress(get_progress() + speed * delta)

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

		if hp <= 0:
			satisfied()

func satisfied():
	is_satisfied = true
	container.get_parent().set_visible(false)
	emotes.set_visible(true)
	emotes.play("satisfied")

func hurt_anim():

	anim_finished = false

	match direction.normalized():
		Vector2.LEFT:
			sprites.play("hurt_left" + str(skin))
			await sprites.animation_finished
			anim_finished = true
		Vector2.RIGHT:
			sprites.play("hurt_right" + str(skin))
			await sprites.animation_finished
			anim_finished = true
		Vector2.DOWN:
			sprites.play("hurt_down" + str(skin))
			await sprites.animation_finished
			anim_finished = true
		Vector2.UP:
			sprites.play("hurt_up" + str(skin))
			await sprites.animation_finished
			anim_finished = true

func add_food_to_container():

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

#func _on_sprites_animation_finished() -> void:
	#anim_finished = true

func set_customer(_food_type: FoodType, _food_amount: int, _has_drink: bool):
	food_type = _food_type
	hp = _food_amount
	has_drink = _has_drink
