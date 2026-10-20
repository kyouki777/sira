extends Node

# Stores the list of animal scene paths or resource references saved during trips
var rescued_animals: Array[PackedScene] = []
var carrying_animal : bool = false
# Tracks what animal the player is currently carrying during a trip
var current_carried_scene: PackedScene = null
var current_carried_texture:Texture2D = null

func add_rescued_animal(animal_scene: PackedScene) -> void:
	if animal_scene:
		rescued_animals.append(animal_scene)
		current_carried_scene = null
		current_carried_texture = null
		print(rescued_animals)
