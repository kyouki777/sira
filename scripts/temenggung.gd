extends StaticBody2D

@onready var interactable : Interactable = $Area2D

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted():
	
	if DayManager.current_day == 1 and GameManager.player_in_village == false:
		print("temenggung dialogue day 1")
		Dialogic.start("temenggung_day_end_1")
		
	elif DayManager.current_day == 2 and GameManager.player_in_village == false:
		print("temenggung dialogue day 2")
		Dialogic.start("temenggung_day_end_2")
		
	elif DayManager.current_day == 3 and GameManager.player_in_village == false:
		print("temenggung dialogue day 3")
		Dialogic.start("temenggung_day_end_3")
		
	#if DayManager.current_day == 1:
		#print("temenggung dialogue day 1")
		#Dialogic.start("temenggung_day_end_1")
		#
	#elif DayManager.current_day == 2:
		#print("temenggung dialogue day 2")
		#Dialogic.start("temenggung_day_end_2")
		#
	#elif DayManager.current_day == 3:
		#print("temenggung dialogue day 3")
		#Dialogic.start("temenggung_day_end_3")
	#
	
	
	if GameManager.talked_to_jitendra and GameManager.player_in_village == true:
		Dialogic.start("temenggung_village1")
		
	else:
		Dialogic.start("havent_talked_to_jitendra")
	
