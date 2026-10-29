extends Sprite2D

# Drag and drop image files into this array in the Inspector
@export var images: Array[Texture2D] = []
var saved_image_steps:Dictionary = {}
var last_image:Texture2D

func _ready() -> void:
	#show_random_image()
	move_deepness(1)

func move_deepness(current_deep:int):
	if not saved_image_steps.has(current_deep):
		var images_pool = images.duplicate()
		if last_image:
			images_pool.erase(last_image)
		last_image = images_pool.pick_random()
		texture = last_image
		
		var current_image_index:int = images.find(texture)
		saved_image_steps.set(current_deep, current_image_index)
		texture = images[current_image_index]
	else:
		texture = images[saved_image_steps.get(current_deep)]

func show_random_image() -> void:
	if images.is_empty():
		push_warning("No images assigned in the inspector!")
		return
		
	var images_pool = images.duplicate()
	if last_image:
		images_pool.erase(last_image)
	last_image = images_pool.pick_random()
	texture = last_image
