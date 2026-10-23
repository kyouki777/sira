extends Node2D

@onready var player: CharacterBody2D = $player

@onready var cutscene_black: ColorRect = $CanvasLayer/cutscene_black
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sira_cutscene: Sprite2D = $OpeningCutscene/sira_cutscene
@onready var jitendra_cutscene: Sprite2D = $OpeningCutscene/jitendra_cutscene
@onready var world_camera: Camera2D = $OpeningCutscene/world_camera

@onready var village_interactable: Node2D = $village_interactable
@onready var animals_interactable: Node = $animals_interactable
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@onready var shadow: Sprite2D = $OpeningCutscene/shadow
@onready var hewan_fed_counter: Label = %HewanFedCounter
@onready var hewan_fed_counter_container: HBoxContainer = $CanvasLayer/HewanFedCounterContaianer
@onready var world_village_label: Label = $CanvasLayer/world_village_label
@onready var enter_game_area: Area2D = $enter_game_area


var animal_fed_count: int = 4
var total_animal_need_food : int = 4


func _ready() -> void:
	#print("opening cutscene off")
	hewan_fed_counter_container.visible = false
	world_village_label.text = ""
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	
	village_interactable.visible = false
	player.player_camera_off()
	cutscene_black.visible = true
	#skip_opening_cutscene()
	#PROBLEM HERE IDKKKKKKKKKK
	if GameManager.has_village_day_end_cutscene == true:
		after_village_day_end_cutscene()
		print("ready after village cutscene")
		#
	elif GameManager.opening_cutscene_played == false:
		play_opening_cutscene()
		print("ready opening cutscene")
	else:
		skip_opening_cutscene()
		print("ready skip")
func _process(delta: float) -> void:
	if animal_fed_count == 4:
		GameManager.day_end = true
		GameManager.feeding_animals = false
		
	if GameManager.feeding_animals and GameManager.talked_to_jitendra == true:
		hewan_fed_counter_container.visible = true

	else:
		hewan_fed_counter_container.visible = false

		
func skip_opening_cutscene():
	cutscene_black.visible = false
	player.player_camera_on()
	village_interactable.visible = true
	world_camera.enabled = false
	
	jitendra_cutscene.visible = false
	shadow.visible = false
	sira_cutscene.visible = false
	player.can_move = true
	
func play_opening_cutscene(): #doing it the hard way yuh pls dont change
	GameManager.opening_cutscene_played = true
	enter_game_area.monitoring = false
	player.can_move = false
	animation_player.play("cutscene_fadein")
	await animation_player.animation_finished
	cutscene_black.visible = false
	animation_player.stop()
	
	#Dialogic.start("opening_cutscene")
	#await Dialogic.timeline_ended
	player.can_move = false
	
	cutscene_black.visible = true
	animation_player.play("cutscene_fadeout")
	await animation_player.animation_finished
	village_interactable.visible = true
	world_camera.enabled = false
	jitendra_cutscene.visible = false
	shadow.visible = false
	sira_cutscene.visible = false
	
	player.player_camera_on()
	animation_player.play("cutscene_fadein")
	await animation_player.animation_finished
	player.can_move = true
	enter_game_area.monitoring = true
	
#FIX THE DETECTION
func _on_enter_game_area_body_entered(body: Node2D) -> void:
	print("player in go to forest area")
	if not player.can_move:
		return
	var distance = global_position.distance_to(body.global_position)
	print("Player triggered area at distance: ", distance)
	if body.is_in_group("player"):
		print("player group detected")
		if GameManager.can_go_to_main_forest == true:
			GameManager.player_in_village = false
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		else:
			Dialogic.start("cant_go_in_there")
		
func _on_dialogic_signal_event(argument:String) -> void:
	if argument == "animal_fed":
		animal_fed_count += 1
		hewan_fed_counter.text = "%s / %s" % [animal_fed_count, total_animal_need_food]
	
	if argument == "day_end":
		player.can_move = false
		animation_player.play("cutscene_fadeout")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/village_day_end_cutscene.tscn")
	
func after_village_day_end_cutscene():
	await Dialogic.timeline_ended
	skip_opening_cutscene()
	player.can_move = true
	village_interactable.queue_free()
	animals_interactable.queue_free()
	canvas_modulate.visible = true
	GameManager.can_go_to_main_forest = true
	Dialogic.start("have_to_get_in_forest")
	print("after village day end cutscene")
	
	
