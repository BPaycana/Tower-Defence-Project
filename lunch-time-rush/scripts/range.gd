extends Area2D

var tower
var player
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	self.set_visible(false)
	player = get_tree().get_first_node_in_group("Player")
	tower = get_parent()

func _physics_process(_delta: float) -> void:
	self.set_visible(false)
	
	if tower.picked_up:
		self.set_visible(true)
		
		if player.is_charging:
			self.set_visible(false)
		
		#if player.anchor_in_range:
			#sprite.modulate = Color("green")
		#else:
			#sprite.modulate = Color("red")
