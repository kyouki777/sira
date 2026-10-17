extends Sprite2D

# Drag and drop image files into this array in the Inspector
@export var images: Array[Texture2D] = []

func _ready() -> void:
	show_random_image()

func show_random_image() -> void:
	if images.is_empty():
		push_warning("No images assigned in the inspector!")
		return
		
	# pick_random() selects a random element from the array
	texture = images.pick_random()
