extends Node2D


func _ready() -> void:

	#Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	Dialogic.signal_event.connect(_on_dialogic_signal_event)

	Dialogic.start("after_village_day_end_cutscene")

#func _on_dialogic_timeline_ended() -> void:
#
	#Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)
	#
	#GameManager.opening_cutscene_played = true
	#get_tree().change_scene_to_file("res://scenes/village.tscn")
	
func _on_dialogic_signal_event(argument:String) -> void:
	if argument == "village_day_end_cutscene_end":
		GameManager.has_village_day_end_cutscene = true
		get_tree().change_scene_to_file("res://scenes/village.tscn")
		
