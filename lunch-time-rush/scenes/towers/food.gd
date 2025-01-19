extends Area2D
class_name Food

@onready var burger: Sprite2D = $Burger
@onready var fries: Sprite2D = $Fries
@onready var drink: Sprite2D = $Drink

@export var speed: float
@export var delete_range: float

var food_type: FoodType
var travelledDistance = 0
var food_damage: int

func _ready() -> void:
	match food_type.name:
		"Burger":
			burger.set_visible(true)
		"Fries":
			fries.set_visible(true)
		"Drink":
			drink.set_visible(true)

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelledDistance += speed * delta
	if travelledDistance > delete_range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if food_type.name == "Drink":
		if body.is_in_group("Customer") && body.get_parent().has_drink:
			body.get_parent().on_hit(food_type ,food_damage)
			queue_free()

	if body.is_in_group("Customer") && body.get_parent().food_type == food_type:
		body.get_parent().on_hit(food_type ,food_damage)
		queue_free()

func set_food(_food_type: FoodType, damage: int):
	food_type = _food_type
	food_damage = damage
