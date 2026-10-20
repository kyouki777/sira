extends Sprite2D

# Drag and drop image files into this array in the Inspector
@export var images: Array[Texture2D] = []
var saved_image_steps:Dictionary = {}

func _ready() -> void:
	#show_random_image()
	move_deepness(1)

func move_deepness(current_deep:int):
	if not saved_image_steps.has(current_deep):
		var current_image_index:int = randi_range(0, images.size()-1)
		saved_image_steps.set(current_deep, current_image_index)
		texture = images[current_image_index]
	else:
		texture = images[saved_image_steps.get(current_deep)]

func show_random_image() -> void:
	if images.is_empty():
		push_warning("No images assigned in the inspector!")
		return
		
	# pick_random() selects a random element from the array
	texture = images.pick_random()
