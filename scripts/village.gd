extends Node2D

@onready var player: CharacterBody2D = $player

@onready var cutscene_black: ColorRect = $CanvasLayer/cutscene_black
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sira_cutscene: Sprite2D = $OpeningCutscene/sira_cutscene
@onready var jitendra_cutscene: Sprite2D = $OpeningCutscene/jitendra_cutscene
@onready var world_camera: Camera2D = $OpeningCutscene/world_camera
@onready var village_interactable: Node2D = $village_interactable

var opening_cutscene_played :bool = false
var can_go_to_main_forest : bool = false
var animal_fed_count: int = 0

func _ready() -> void:
	#print("opening cutscene off")
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	
	village_interactable.visible = false
	player.player_camera_off()
	cutscene_black.visible = true
	
	if not opening_cutscene_played:
		play_opening_cutscene()
		

func _process(delta: float) -> void:
	if animal_fed_count == 4:
		print(" all animals fed. play fire scene")

func play_opening_cutscene(): #doing it the hard way yuh pls dont change
	opening_cutscene_played = true
	player.can_move = false
	animation_player.play("cutscene_fadein")
	await animation_player.animation_finished
	cutscene_black.visible = false
	animation_player.stop()
	
	Dialogic.start("opening_cutscene")
	await Dialogic.timeline_ended
	player.can_move = false
	
	cutscene_black.visible = true
	animation_player.play("cutscene_fadeout")
	await animation_player.animation_finished
	village_interactable.visible = true
	world_camera.enabled = false
	jitendra_cutscene.visible = false
	sira_cutscene.visible = false
	
	player.player_camera_on()
	animation_player.play("cutscene_fadein")
	await animation_player.animation_finished
	player.can_move = true
	

func _on_enter_game_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_go_to_main_forest == true:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		GameManager.player_in_village = false
	else:
		Dialogic.start("cant_go_in_there")
		
func _on_dialogic_signal_event(argument:String) -> void:
	if argument == "animal_fed":
		animal_fed_count += 1
		print(animal_fed_count)
	
	
