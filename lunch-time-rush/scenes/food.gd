extends Area2D
class_name Food

var my_scene: PackedScene = load("res://scenes/food.tscn")

@export var speed: float
@export var range: float

var travelledDistance = 0
var food_damage: int

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelledDistance += speed * delta
	if travelledDistance > range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Customer"):
		body.get_parent().on_hit(food_damage)
		queue_free()

func set_food(damage: int):
	food_damage = damage
