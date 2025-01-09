extends TextureProgressBar

var parent

func _ready() -> void:
	parent = get_parent()
	min_value = parent.food_min
	max_value = parent.food_max

func _process(delta: float) -> void:
	self.value = parent.food_amount
