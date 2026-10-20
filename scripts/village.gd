extends Node2D

@onready var player: CharacterBody2D = $player

@onready var cutscene_black: ColorRect = $CanvasLayer/cutscene_black
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var jitendra_cutscene: Sprite2D = $OpeningCutscene/jitendra_cutscene
@onready var world_camera: Camera2D = $OpeningCutscene/world_camera

var opening_cutscene_played = false

func _ready() -> void:
	#print("opening cutscene off")
	player.player_camera_off()
	cutscene_black.visible = true
	
	if not opening_cutscene_played:
		play_opening_cutscene()
		

func _process(delta: float) -> void:
	pass

func play_opening_cutscene(): #doing it the hard way yuh pls dont change
	opening_cutscene_played = true
	player.can_move = false
	animation_player.play("cutscene_fadein")
	await animation_player.animation_finished
	cutscene_black.visible = false
	animation_player.stop()
	
	Dialogic.start("opening_cutscene")
	await Dialogic.timeline_ended
	
	cutscene_black.visible = true
	animation_player.play("cutscene_fadeout")
	await animation_player.animation_finished
	world_camera.enabled = false
	jitendra_cutscene.visible = false
	
	player.player_camera_on()
	animation_player.play("cutscene_fadein")
	await animation_player.animation_finished
	player.can_move = true


func _on_enter_game_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
