extends Node

# Stores the list of animal scene paths or resource references saved during trips
var rescued_animals: Array[PackedScene] = []
var carrying_animal : bool = false
# Tracks what animal the player is currently carrying during a trip
var current_carried_scene: PackedScene = null
var current_carried_texture:Texture2D = null
var tutorial_shown: bool = false

#for spawn point
var player_entered_forest : bool = false

# village stuff
var player_in_village = true

var talked_to_jitendra: bool = false
var feeding_animals :bool = false
var day_end : bool = false
var has_village_day_end_cutscene :bool = false
var opening_cutscene_played :bool = false
var can_go_to_main_forest : bool = false
var manuk_pansuh_acquired : bool = false

#for triggering last day search
var last_day : bool = false
var jitendra_lawung_spawned:bool = false

var day_transitioning : bool = false

func add_rescued_animal(animal_scene: PackedScene) -> void:
	if animal_scene:
		rescued_animals.append(animal_scene)
		current_carried_scene = null
		current_carried_texture = null
		print(rescued_animals)

func feed_animals_started():
	feeding_animals = true
	Dialogic.VAR.feeding_animals = true
	print("feeding animals started")

func reset_game() -> void:
	print("game manager: reset")
	rescued_animals.clear()
	carrying_animal = false
	current_carried_scene = null
	current_carried_texture = null
	player_entered_forest = false
	last_day = false
	day_transitioning = false
