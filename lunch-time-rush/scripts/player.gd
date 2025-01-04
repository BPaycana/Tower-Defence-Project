class_name Player
extends CharacterBody2D

var player_direction : Vector2

#func _ready() -> void:
	#animation_tree.set("parameters/Idle/blend_position", starting_direction)

#func _physics_process(delta: float) -> void:
	
	
