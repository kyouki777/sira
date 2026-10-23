extends Node2D


@export var village_scene : PackedScene
func _ready() -> void:

	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	
	await get_tree().process_frame
	
	Dialogic.start("kumang")

func _on_dialogic_timeline_ended() -> void:

	Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)
	
	GameManager.opening_cutscene_played = true
	#get_tree().(village_scene)
