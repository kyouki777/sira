extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var label: Label = $CanvasLayer/Label
@onready var narrator: Label = $CanvasLayer/narrator


func _ready() -> void:
	color_rect.visible = true
	label.visible = false
	
	Dialogic.start("jitendra_headband")
	await Dialogic.timeline_ended
	
	animation_player.play("zoom_out")
	audio_stream_player.play()
	
	await animation_player.animation_finished
	print("waiting")
	await get_tree().create_timer(3).timeout

	animation_player.play("label")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file("res://MainMenu.tscn")
