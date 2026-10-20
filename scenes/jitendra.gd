extends StaticBody2D

@onready var interactable : Interactable = $Area2D


func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	

func _on_interacted():
	Dialogic.start("jitendra1_feedinganimals")
