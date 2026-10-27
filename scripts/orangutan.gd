extends StaticBody2D

@onready var jitendra: StaticBody2D = $"../../village_interactable/jitendra"
@onready var interactable : Interactable = $Area2D

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted():

	if GameManager.player_in_village == false:
		Dialogic.start("main_orangutan")
		
	if GameManager.talked_to_jitendra and GameManager.player_in_village == true:
		Dialogic.start("feed_orangutan")
	else:
		Dialogic.start("havent_talked_to_jitendra")
