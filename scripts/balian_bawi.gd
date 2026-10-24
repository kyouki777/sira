extends StaticBody2D

@onready var jitendra: StaticBody2D = $"../../village_interactable/jitendra"
@onready var interactable : Interactable = $Area2D

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted():
	if DayManager.current_day == 1  and GameManager.player_in_village == false:
		print("balian dialogue day 1")
		Dialogic.start("balian_day_end_1")
		
	elif DayManager.current_day == 2 and GameManager.player_in_village == false:
		print("balian dialogue day 2")
		Dialogic.start("balian_day_end_2")
		
	elif DayManager.current_day == 3 and GameManager.player_in_village == false:
		print("balian dialogue day 3")
		Dialogic.start("balian_day_end_3")
		
	if GameManager.talked_to_jitendra and GameManager.player_in_village == true:
		Dialogic.start("balian_village")
		
	else:
		Dialogic.start("havent_talked_to_jitendra")
