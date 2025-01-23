extends Node
@onready var tutorial: Control = $Tutorial

func _ready() -> void:
	get_node("MainMenu/MarginContainer/VBoxContainer/Play").pressed.connect(on_play_pressed)
	get_node("MainMenu/MarginContainer/VBoxContainer/Quit").pressed.connect(on_quit_pressed)
	get_node("MainMenu/MarginContainer/VBoxContainer/Tutorial").pressed.connect(_tutorial)
	get_node("Tutorial/MarginContainer/Button/Return").pressed.connect(_tutorial)
	

func _tutorial():
	if tutorial.visible == false:
		tutorial.set_visible(true)
	else:
		tutorial.set_visible(false)

func on_play_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://scenes/levels/level1/level_1.tscn").instantiate()
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()
	
