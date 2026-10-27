extends StaticBody2D

@onready var interactable : Interactable = $Area2D

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted():

	if GameManager.talked_to_jitendra and GameManager.player_in_village == true:
		Dialogic.start("macan_dahan")
	else:
		Dialogic.start("havent_talked_to_jitendra")
