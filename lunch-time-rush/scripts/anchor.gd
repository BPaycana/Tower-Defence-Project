extends Area2D

var occupied = false

func _physics_process(_delta: float) -> void:
	print_debug(occupied)
