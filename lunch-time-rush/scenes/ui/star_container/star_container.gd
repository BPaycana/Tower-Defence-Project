extends HBoxContainer

@onready var star_gui = preload("res://scenes/ui/star_container/star_gui.tscn")

func set_max_stars(max_stars: int):
	for i in range(max_stars):
		var star = star_gui.instantiate()
		add_child(star)

func update_stars(current_stars: int):
	var stars = get_children()
	
	for i in range(current_stars):
		stars[i].update(true)
	
	for i in range(current_stars, stars.size()):
		stars[i].update(false)
