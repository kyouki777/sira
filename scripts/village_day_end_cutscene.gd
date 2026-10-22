extends Node2D

func _ready() -> void:

	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	
	await get_tree().process_frame
	
	Dialogic.start("village_day_end_cutscene")

func _on_dialogic_timeline_ended() -> void:

	Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)
	
	GameManager.opening_cutscene_played = true
	get_tree().change_scene_to_file("res://scenes/village.tscn")
