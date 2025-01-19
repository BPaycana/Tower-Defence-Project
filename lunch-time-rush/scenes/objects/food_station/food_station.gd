extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
var player
var is_in_food_station = false


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pick_up") && is_in_food_station && !player.pick_up:
		player._pick_up_food()

func _on_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("Player"):
		is_in_food_station = true
		player = body
		sprite.modulate = Color("green")

func _on_body_exited(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("Player"):
		is_in_food_station = false
		player = body
		sprite.modulate = Color(1, 1, 1, 1)
