extends Area2D
class_name Interactable

signal interacted

@export var prompt_message: String = "Talk"

func interact() -> void:
	interacted.emit()
