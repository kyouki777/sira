extends Node2D

@export var animal_scenes: Array[PackedScene] = []
@export var screen_margin: float = 100.0

# Special last day settings
@export var special_last_day_jitendra: PackedScene 
@export var target_last_day_progress: int = 10

@onready var saved_animal: Sprite2D = %SavedAnimal
var animal_room_list: Dictionary = {}
var current_animal_in_room: Control
var is_animal_picked_up: bool = false

func move_towards_room(progress_number: int) -> void:
	if progress_number == 1:
		return
	if current_animal_in_room:
		current_animal_in_room.hide()
	if animal_room_list.has(progress_number):
		current_animal_in_room = animal_room_list.get(progress_number)
		if not is_animal_picked_up and current_animal_in_room:
			current_animal_in_room.show()
		return

	# LAST DAY: ONLY SPAWN THE HAT 
	if GameManager.last_day:
		if progress_number == target_last_day_progress and special_last_day_jitendra:
			spawn_animal(progress_number, special_last_day_jitendra)
			print("JITENDRA'S LAWUNG SPAWNED")
		else:
			animal_room_list.set(progress_number, null)
		return

	# NORMAL DAYS: RANDOM ANIMALS 
	var spawn_chance: float = lerp(0.0, 1.0, progress_number / 10.0)
	if randf() < spawn_chance:
		spawn_animal(progress_number)
	else:
		animal_room_list.set(progress_number, null)

func spawn_animal(progress_number: int = 5, custom_scene: PackedScene = null) -> void:
	var selected_scene: PackedScene = custom_scene
	
	if not selected_scene:
		if animal_scenes.is_empty():
			push_warning("No animal scenes assigned in animal_scenes array!")
			return
		selected_scene = animal_scenes.pick_random()

	var animal_instance = selected_scene.instantiate()
	var screen_size = get_viewport_rect().size

	# Place custom items (hat) dead-center and place random animals at random coordinates
	if custom_scene != null:
		animal_instance.global_position = screen_size / 2.0
	else:
		var margin: float = screen_margin
		var random_x = randf_range(margin, screen_size.x - margin)
		var random_y = randf_range(margin, screen_size.y - margin)
		animal_instance.global_position = Vector2(random_x, random_y)

	animal_instance.scale = Vector2(3.0, 3.0)
	
	add_child(animal_instance)
	animal_room_list.set(progress_number, animal_instance)
	current_animal_in_room = animal_instance
	
	if "animal_scene" in animal_instance:
		animal_instance.animal_scene = selected_scene
	elif animal_instance.has_node("TextureButton") and "animal_scene" in animal_instance.get_node("TextureButton"):
		animal_instance.get_node("TextureButton").animal_scene = selected_scene
		
	if animal_instance.has_signal("saved_animal_texture"):
		animal_instance.saved_animal_texture.connect(take_animal_on_top)

func take_animal_on_top(texture: Texture2D) -> void:
	saved_animal.texture = texture
	is_animal_picked_up = true
