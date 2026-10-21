extends StaticBody2D

@onready var jitendra: StaticBody2D = $"../../village_interactable/jitendra"
@onready var interactable : Interactable = $Area2D

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted():

	if jitendra.talked_to_jitendra and GameManager.player_in_village == true:
		Dialogic.start("jalung")
		
	else:
		Dialogic.start("havent_talked_to_jitendra")
