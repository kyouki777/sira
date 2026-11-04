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

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var world_borders: Node2D = $WorldBorders

var animal_fed_count: int = 0
var total_animal_need_food : int = 5
var day_end_triggered: bool = false
var player_camera:Camera2D

func _ready() -> void:
	#print("opening cutscene off")
	world_village_label.text = ""

		
	if not GameManager.has_village_day_end_cutscene:
		audio_stream_player.play()
		print("village ambience playing")
		
	hewan_fed_counter_container.visible = false
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	world_camera.enabled = true
	
	village_interactable.visible = false
	player.player_camera_off()
	player_camera = player.camera_2d as Camera2D
	cutscene_black.visible = true
	setup_camera_limits()
	
	#skip_opening_cutscene() #dont forget to comment this
	
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
	
	if GameManager.talked_to_jitendra == false and GameManager.opening_cutscene_played == true and not GameManager.feeding_animals : #yes im doing it the hard way
		world_village_label.visible = true
		world_village_label.text = "Talk to Jitendra"
	
	if GameManager.feeding_animals: #disables label after talking to jitendra
		world_village_label.visible = false
		
	if animal_fed_count == total_animal_need_food and not day_end_triggered:
		day_end_triggered = true
		print("day ending")
		
		Dialogic.start("report_to_jitendra")
		print("dialogic playing report to jitendra")
		await Dialogic.timeline_ended
		
		GameManager.day_end = true
		GameManager.feeding_animals = false
		
	if animal_fed_count == total_animal_need_food:
		world_village_label.visible = true
		world_village_label.text = "Report to Jitendra"
		print("REPORT TO JITENDRA")
		
	#if GameManager.has_village_day_end_cutscene == true: #after village day end cutscene
		#world_village_label.visible = true
		#world_village_label.text = "Enter the Sacred Forest"
		
	if GameManager.player_in_village == false: #disables UI when the player exits the village
		world_village_label.visible = false
		
	#animal feed counter UI
	if GameManager.feeding_animals and GameManager.talked_to_jitendra == true:
		hewan_fed_counter_container.visible = true

	else:
		hewan_fed_counter_container.visible = false

func skip_opening_cutscene():
	print("skip opening func")
	cutscene_black.visible = false
	player.player_camera_on()
	village_interactable.visible = true
	world_camera.enabled = false
	
	jitendra_cutscene.visible = false
	shadow.visible = false
	sira_cutscene.visible = false
	player.can_move = true
	
	
# Tween helper functions for screen fades
func fade_out(duration: float = 1.0) -> void:
	print("tween fade out")
	cutscene_black.visible = true
	cutscene_black.modulate.a = 0.0
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(cutscene_black, "modulate:a", 1.0, duration)
	await tween.finished

func fade_in(duration: float = 1.0) -> void:
	print("tween fade in")
	cutscene_black.visible = true
	cutscene_black.modulate.a = 1.0
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(cutscene_black, "modulate:a", 0.0, duration)
	await tween.finished
	cutscene_black.visible = false


func play_opening_cutscene(): #doing it the hard way yuh pls dont change
	
	enter_game_area.monitoring = false
	player.can_move = false
	
	animation_player.play("cutscene_fadeincamera")
	await animation_player.animation_finished
	print("fade in finished")
	
	# Freeze animation state so camera stays at the dragged position without snapping back
	animation_player.stop(true)
	cutscene_black.visible = false
	
	Dialogic.start("opening_cutscene")
	await Dialogic.timeline_ended
	player.can_move = false # cancels out player's after dialogic can move func
	
	# Fade Out to black 
	await fade_out(1.0)
	print("3. Fade out finished")
	
	village_interactable.visible = true
	world_camera.enabled = false
	jitendra_cutscene.visible = false
	shadow.visible = false
	sira_cutscene.visible = false
	
	player.player_camera_on()
	
	# Fade In to gameplay
	await fade_in(1.0)
	
	player.can_move = true
	enter_game_area.monitoring = true
	$CanvasLayer/MoveTutorial.show_up()
	GameManager.opening_cutscene_played = true
	
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
			await get_tree().process_frame
			get_tree().change_scene_to_file("res://scenes/main.tscn")
			TimeManager.start_day_timer()
		else:
			Dialogic.start("cant_go_in_there")
		
func _on_dialogic_signal_event(argument:String) -> void:
	if argument == "animal_fed":
		animal_fed_count += 1
		hewan_fed_counter.text = "%s / %s" % [animal_fed_count, total_animal_need_food]
	
	if argument == "day_end":
		player.can_move = false #animation not playing yet
		animation_player.play("cutscene_fadeout")
		print("cutscene fadeout day end")
		await animation_player.animation_finished
		audio_stream_player.stop() #to make sure the audio stops
		get_tree().change_scene_to_file("res://scenes/village_day_end_cutscene.tscn")
	
	if argument == "manuk_pansuh":
		GameManager.manuk_pansuh_acquired = true
		print("manuk pansuh acquired")
	
func after_village_day_end_cutscene():
	GameManager.has_village_day_end_cutscene = true
	await Dialogic.timeline_ended
	audio_stream_player.stop()
	skip_opening_cutscene()
	player.can_move = true
	village_interactable.queue_free()
	animals_interactable.queue_free()
	canvas_modulate.visible = true
	GameManager.can_go_to_main_forest = true
	Dialogic.start("have_to_get_in_forest")
	print("after village day end cutscene")

func setup_camera_limits() -> void:
	if not world_borders or not player_camera:
		push_warning("LevelLimits parent or Camera2D is not assigned in LevelManager.")
		return

	for child in world_borders.get_children():
		var shape:CollisionShape2D = child.get_node_or_null("CollisionShape2D") as CollisionShape2D
		var pos: Vector2 = shape.global_position if shape else child.global_position
		var col_shape:WorldBoundaryShape2D = shape.shape as WorldBoundaryShape2D
		var normal_direction:Vector2 = col_shape.normal
		if normal_direction == Vector2.RIGHT:
			player_camera.limit_left = int(pos.x)
		elif normal_direction == Vector2.LEFT:
			player_camera.limit_right = int(pos.x)
		elif normal_direction == Vector2.DOWN:
			player_camera.limit_top = int(pos.y)
		elif normal_direction == Vector2.UP:
			player_camera.limit_bottom = int(pos.y)
