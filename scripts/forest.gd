extends Node2D

var current_progress :int = 1

var has_spawned_animal: bool = false
var animal_data: Dictionary = {}
var target_spawn_step: int = 0
var tutorial_shown : bool = false

@onready var forest_bg = $forest_bg
@onready var time_limit = $time_limit
@export var world_label :Label
@export var depth_label:Label
@onready var hewan_counter: Label = %HewanCounter
@export var animal_container: Node2D
@onready var timer_container: HBoxContainer = $UILayer/TimerContainer
@onready var hewan_container: HBoxContainer = $UILayer/HewanContainer


var label_on :bool = false

func _ready() -> void:
	GameManager.carrying_animal = false
	world_label.text = ""
	target_spawn_step = randi_range(3, 30)
	
	if GameManager.last_day == true:
		timer_container.visible = false #so that the player only relies on oxygen as time inside the forest
		hewan_container.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_progress == 0 and GameManager.last_day == true and label_on == false: #player cant go back
		label_on = true
		world_label.text = "I can't go back. I need to find Jitendra."
		await get_tree().create_timer(3).timeout
		world_label.text = ""
		label_on = false
		
	if current_progress == 0 and GameManager.last_day == false:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"):
		if not GameManager.carrying_animal:
			move_forward()
		else:
			cant_move_forward()

	if Input.is_action_just_pressed("down"):
		move_backwards()

func move_forward():
	current_progress += 1
	#forest_bg.show_random_image()
	forest_bg.move_deepness(current_progress)
	if depth_label:
		depth_label.text = "Forest depth: %d m" % [current_progress * 100]
	animal_container.move_towards_room(current_progress)

func move_backwards():
	if GameManager.last_day == true:
		if current_progress == 0: #prevents going backward too much in the last day
			return
	current_progress -= 1
	if depth_label:
		depth_label.text = "Forest depth: %d m" % [current_progress * 100]
	#forest_bg.show_random_image()
	forest_bg.move_deepness(current_progress)
	animal_container.move_towards_room(current_progress)

#make a function to detect how many animals were found and put it in the main scene. or maybe only save one animal per trip inside the forest

func cant_move_forward():
	world_label.text = "I can't go in further. I have to bring back the animal I'm carrying."
	await get_tree().create_timer(3).timeout
	world_label.text = ""

# Inside forest/exploration scene script when picking up an animal:
func pick_up_animal(animal_scene: PackedScene) -> void:
	GameManager.current_carried_scene = animal_scene
	GameManager.carrying_animal = true

func trigger_gameover():
	#world_label.text = "GAMEOVER, YOU DIED!"
	get_tree().paused = true
	print("GAMEOVER")
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func _on_falling_branch_component_dead_by_falling_branch() -> void:
	trigger_gameover()
