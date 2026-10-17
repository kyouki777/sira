extends Node2D

@onready var world_label: Label = $CanvasLayer/world_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_forest_area_body_entered(body: Node2D) -> void:
	if GameManager.carrying_animal == false:
		get_tree().change_scene_to_file("res://scenes/forest.tscn")
	else:
		world_label.text = "I need to put the injured animal in a safe place."
		
func _on_forest_area_body_exited(body: Node2D) -> void:
	world_label.text = ""
