extends Node2D

@export_category("Path")
@export var path1: Path2D
@export var path2: Path2D

@export_category("FoodType")
@export var fries: FoodType
@export var burger: FoodType

@export_category("Objects")
@export var tv: Node2D

@export_category("UI")
@export var star_container: HBoxContainer
@onready var button: Button = $CanvasLayer/Button
@onready var game_over: Control = $CanvasLayer/GameOver
@onready var congratulations: Control = $CanvasLayer/Congratulations


@export_category("Level Data")
@export var level_data: LevelData



var wave_data = null
var wave_number: int = 0
var customers_in_wave = 0

var max_stars: int = 5
var current_stars: int

func _ready() -> void:
	
	tv.get_child(0).text = "[color=gray][wave amp=10.0 freq=10.0 connected=1]" + "  x " + str(customers_in_wave)
	current_stars = max_stars
	star_container.set_max_stars(max_stars)
	star_container.update_stars(current_stars)
	
func _physics_process(delta: float) -> void:
	if current_stars > 0 && wave_number >= 2:
		congratulations.set_visible(true)

func start_wave():
	
	if level_data == null:
		print("No wave data assigned!")
		return
		
	wave_data = retrieve_wave_data()
	
	for customer_data in wave_data.customers:
		spawn_customer(customer_data)
		await get_tree().create_timer(wave_data.spawn_delay).timeout

func retrieve_wave_data():
	var new_wave_data = level_data.wave[wave_number]
	customers_in_wave = new_wave_data.customers.size()
	tv.get_child(0).text = "[color=gray][wave amp=10.0 freq=10.0 connected=1]" + "  x " + str(customers_in_wave)
	return new_wave_data

func decide_path() -> Path2D:
	if randi() % 2 == 0:
		return path1
	else:
		return path2

func spawn_customer(customer_data):

	var new_customer = load("res://scenes/customer/customer.tscn").instantiate()
	new_customer.set_customer(customer_data.food_type, customer_data.hp, customer_data.has_drink)
	decide_path().add_child(new_customer)

func customer_unsatisfied():
	current_stars -= 1
	star_container.update_stars(current_stars)
	if current_stars <= 0:
		game_over.set_visible(true)

func _on_button_button_down() -> void:
	if wave_number < level_data.wave.size():
		button.set_visible(false)
		start_wave()

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
