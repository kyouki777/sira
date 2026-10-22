extends Node2D

@export var animal_scenes: Array[PackedScene] = []
@export var screen_margin:float = 100.0
@onready var saved_animal: Sprite2D = %SavedAnimal
var animal_room_list:Dictionary = {}
var current_animal_in_room:Control
var is_animal_picked_up:bool = false

func move_towards_room(progress_number:int) -> void:
	if progress_number == 1:
		return
	if current_animal_in_room:
		current_animal_in_room.hide()
	if animal_room_list.has(progress_number):
		current_animal_in_room = animal_room_list.get(progress_number)
		if not is_animal_picked_up and current_animal_in_room:
			current_animal_in_room.show()
		return
	# Probability checking here
	var spawn_chance:float = lerp(0.0, 1.0, progress_number / 10.0)
	if randf() < spawn_chance:
		spawn_random_animal(progress_number)
	else:
		animal_room_list.set(progress_number, null)

func spawn_random_animal(progress_number:int = 5) -> void:
	if animal_scenes.is_empty():
		push_warning("No animal scenes assigned in animal_scenes array!")
		return

	var selected_scene: PackedScene = animal_scenes.pick_random()

	var screen_size = get_viewport_rect().size
	var margin: float = screen_margin
	var random_x = randf_range(margin, screen_size.x - margin)
	var random_y = randf_range(margin, screen_size.y - margin)

# Scale up for the forest screen view (e.g., 3x or 4x size)

	var animal_instance = selected_scene.instantiate()
	animal_instance.global_position = Vector2(random_x, random_y)
	animal_instance.scale = Vector2(3.0, 3.0)
	
	# Add child FIRST so owner can be assigned
	add_child(animal_instance)
	animal_room_list.set(progress_number, animal_instance)
	current_animal_in_room = animal_instance
	
	# If  animal script or button has an export var for animal_scene:
	if "animal_scene" in animal_instance:
		animal_instance.animal_scene = selected_scene
	elif animal_instance.has_node("TextureButton") and "animal_scene" in animal_instance.get_node("TextureButton"):
		animal_instance.get_node("TextureButton").animal_scene = selected_scene
	if animal_instance.has_signal("saved_animal_texture"):
		animal_instance.saved_animal_texture.connect(take_animal_on_top)

func take_animal_on_top(texture:Texture2D):
	saved_animal.texture = texture
	is_animal_picked_up = true
