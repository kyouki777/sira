extends Node2D

@onready var world_label: Label = $CanvasLayer/world_label
const FOREST = preload("uid://djsik0vi5b8k2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_label.text = ""

func _on_forest_area_body_entered(_body: Node2D) -> void:
	if GameManager.carrying_animal == false and not DayManager.has_all_animals_saved():
		go_to_forest()
	elif DayManager.has_all_animals_saved():
		world_label.text = "All animals have been saved today."
	else:
		world_label.text = "I need to put the injured animal in a safe place."

func go_to_forest():
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/forest.tscn")

func _on_forest_area_body_exited(_body: Node2D) -> void:
	world_label.text = ""
