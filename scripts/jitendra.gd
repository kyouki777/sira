extends StaticBody2D



var current_dialogue_index: int = 0
var jitendra_manuk_pansuh_played : bool = false

@onready var interactable: Interactable = $Area2D

@export var ordered_timelines: Array[String] = [
	"jitendra1_village", 
	"jitendra2_village",
	"jitendra_option" 
]

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted() -> void:
	
	if DayManager.current_day == 1 and GameManager.player_in_village == false and GameManager.day_transitioning == true:
		print("jitendra day 1 dialogue")
		Dialogic.start("jitendra_day_end_1")
		
	elif DayManager.current_day == 2 and GameManager.player_in_village == false and GameManager.day_transitioning == true:
		print("jitendra day 2 dialogue")
		Dialogic.start("jitendra_day_end_2")
		
	if GameManager.player_in_village == false:
		Dialogic.start("jitendra_sanctuary")
		print("jitendra sanctuary dialogue")
		
	#if DayManager.current_day == 1:
		#print("jitendra day 1 dialogue")
		#Dialogic.start("jitendra_day_end_1")
		#
	#elif DayManager.current_day == 2:
		#print("jitendra day 2 dialogue")
		#Dialogic.start("jitendra_day_end_2")
		#
		#
		#
		
	if GameManager.day_end and GameManager.player_in_village == true:
		print("player day end")
		Dialogic.start("jitendra_day_end")
		return 
		
	if GameManager.manuk_pansuh_acquired == true and jitendra_manuk_pansuh_played == false:
		Dialogic.start("jitendra_manuk_pansuh")
		print("jitendra manuk pansuh dialogue playing")
		jitendra_manuk_pansuh_played = true
		
	if ordered_timelines.is_empty():
		return
		
	
	var chosen_timeline: String = ordered_timelines[current_dialogue_index]
	Dialogic.start(chosen_timeline)
	
	if current_dialogue_index == 2:
		GameManager.talked_to_jitendra = true
		print("jitendra all dialogue option finished")
	
	if current_dialogue_index < ordered_timelines.size() - 1:
		current_dialogue_index += 1
