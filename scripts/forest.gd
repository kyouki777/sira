extends Node2D

var current_progress = 1
@onready var forest_bg = $forest_bg
@export var animal_scenes: Array[PackedScene] = []

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		move_forward()
		
	if Input.is_action_just_pressed("down"):
		move_backwards()
	
	if current_progress == 0:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func move_forward():
	print("moving forward")
	forest_bg.show_random_image()

	current_progress += 1
	print("current progress: ", current_progress)
	
	if current_progress == 5:
		spawn_random_animal()
		
func move_backwards():
	print("moving backwards")
	forest_bg.show_random_image()
	current_progress -= 1
	print("current progress: ", current_progress)

#make a function to detect how many animals were found and put it in the main scene. or maybe only save one animal per trip inside the forest

func spawn_random_animal() -> void:
	if animal_scenes.is_empty():
		push_warning("No animal scenes assigned in animal_scenes array!")
		return

	# Randomly select one animal scene from the array
	var selected_scene: PackedScene = animal_scenes.pick_random()

	#  Calculate random position within viewport bounds
	var screen_size = get_viewport_rect().size
	var margin: float = 32.0
	var random_x = randf_range(margin, screen_size.x - margin)
	var random_y = randf_range(margin, screen_size.y - margin)

	#Instantiate and position the selected animal
	var animal_instance = selected_scene.instantiate()
	animal_instance.global_position = Vector2(random_x, random_y)
	add_child(animal_instance)
