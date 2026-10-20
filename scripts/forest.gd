extends Node2D

var current_progress :int = 1

var has_spawned_animal: bool = false
var animal_data: Dictionary = {}
var target_spawn_step: int = 0
var tutorial_shown : bool = false

@onready var forest_bg = $forest_bg
@export var animal_scenes: Array[PackedScene] = []
@onready var time_limit = $time_limit
@export var world_label :Label
@onready var hewan_counter: Label = %HewanCounter
@onready var saved_animal: Sprite2D = %SavedAnimal

func _ready() -> void:
	GameManager.carrying_animal = false
	world_label.text = ""
	target_spawn_step = randi_range(3, 30)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		if not GameManager.carrying_animal:
			move_forward()
		else:
			cant_move_forward()

	if Input.is_action_just_pressed("down"):
		move_backwards()
	
	if current_progress == 0:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func move_forward():
	print("moving forward")

	current_progress += 1
	#forest_bg.show_random_image()
	forest_bg.move_deepness(current_progress)
	print("current progress: ", current_progress)
	
	if current_progress == 5:
		spawn_random_animal()

func move_backwards():
	print("moving backwards")
	current_progress -= 1
	print("current progress: ", current_progress)
	#forest_bg.show_random_image()
	forest_bg.move_deepness(current_progress)

#make a function to detect how many animals were found and put it in the main scene. or maybe only save one animal per trip inside the forest

func cant_move_forward():
	world_label.text = "I can't go in further. I have to bring back the animal I'm carrying."
	await get_tree().create_timer(3).timeout
	world_label.text = ""
	
func spawn_random_animal() -> void:
	if animal_scenes.is_empty():
		push_warning("No animal scenes assigned in animal_scenes array!")
		return

	var selected_scene: PackedScene = animal_scenes.pick_random()

	var screen_size = get_viewport_rect().size
	var margin: float = 50.0
	var random_x = randf_range(margin, screen_size.x - margin)
	var random_y = randf_range(margin, screen_size.y - margin)

# Scale up for the forest screen view (e.g., 3x or 4x size)

	var animal_instance = selected_scene.instantiate()
	animal_instance.global_position = Vector2(random_x, random_y)
	animal_instance.scale = Vector2(3.0, 3.0)
	
	# Add child FIRST so owner can be assigned
	add_child(animal_instance)
	animal_instance.owner = self
	
	# If  animal script or button has an export var for animal_scene:
	if "animal_scene" in animal_instance:
		animal_instance.animal_scene = selected_scene
	elif animal_instance.has_node("TextureButton") and "animal_scene" in animal_instance.get_node("TextureButton"):
		animal_instance.get_node("TextureButton").animal_scene = selected_scene
	if animal_instance.has_signal("saved_animal_texture"):
		animal_instance.saved_animal_texture.connect(take_animal_on_top)

func take_animal_on_top(texture:Texture2D):
	saved_animal.texture = texture

# Inside forest/exploration scene script when picking up an animal:
func pick_up_animal(animal_scene: PackedScene) -> void:
	GameManager.current_carried_scene = animal_scene
	GameManager.carrying_animal = true

func trigger_gameover():
	world_label.text = "GAMEOVER, YOU DIED!"
	get_tree().paused = true
	print("GAMEOVER")

func _on_falling_branch_component_dead_by_falling_branch() -> void:
	trigger_gameover()

	
