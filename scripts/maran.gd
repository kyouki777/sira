extends Node2D

func _ready() -> void:
	
	if Dialogic.current_timeline:
		Dialogic.end_timeline()
	
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	Dialogic.start("village_day_end_cutscene")

func _on_dialogic_timeline_ended() -> void:
	if Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)
	
	GameManager.has_village_day_end_cutscene = true
	GameManager.opening_cutscene_played = true
	get_tree().change_scene_to_file("res://scenes/village.tscn")
