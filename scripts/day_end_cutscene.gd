extends Node2D

@onready var world_borders: Node2D = $WorldBorders
@onready var player: CharacterBody2D = $player
var player_camera: Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var world_label: Label = $CanvasLayer/world_label
@onready var jitendra: StaticBody2D = $jitendra
@onready var layer_3: TileMapLayer = $TileMap2/layer3
@onready var haze: ColorRect = $CanvasLayer/haze
@onready var fire_sound: AudioStreamPlayer = $fire_sound
@onready var balian_bawi: StaticBody2D = $balian_bawi
@onready var temenggung: StaticBody2D = $temenggung

var can_go_to_forest: bool = false

var talked_to_balian: bool = false
var talked_to_temenggung: bool = false
var talked_to_jitendra: bool = false

func _ready() -> void:
	layer_3.visible = false
	haze.visible = false
	
	player_camera = player.camera_2d
	setup_camera_limits()
	Dialogic.signal_event.connect(_on_dialogic_signal_event)
	
	if DayManager.current_day == 2:
		haze.visible = true
		
	if DayManager.current_day == 3:
		jitendra.queue_free()
		print("despawning jitendra")
		layer_3.visible = true
		haze.visible = true
		fire_sound.play()
		
	player.can_move = false
	animation_player.play("fadein")
	await animation_player.animation_finished
	player.can_move = true
	


func _on_dialogic_signal_event(argument: String) -> void:

	match argument:
		"talked_to_balian":
			talked_to_balian = true
		"talked_to_temenggung":
			talked_to_temenggung = true
		"talked_to_jitendra":
			talked_to_jitendra = true
		"balian_last_day":
			talked_to_balian = true
		"temenggung_last_day":
			talked_to_temenggung = true #not used yet


	if talked_to_balian and (argument == "balian_last_day"):
		can_go_to_forest = true
		#DayManager.go_to_next_day()#go to day 4, gajadiii
		#print("total time:", DayManager.day_total_time) 
		print("area2d forest on")

	if talked_to_balian and talked_to_temenggung and talked_to_jitendra:
		_trigger_day_transition()

func _trigger_day_transition() -> void:
	
	fire_sound.stop()
	talked_to_balian = false
	talked_to_temenggung = false
	talked_to_jitendra = false

	if DayManager.current_day == 1:
		await Dialogic.timeline_ended
		player.can_move = false
		animation_player.play("fadeout_day_2")
		await animation_player.animation_finished
		player.can_move = true
		DayManager.go_to_next_day()
		GameManager.day_transitioning = false
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		
	elif DayManager.current_day == 2:
		await Dialogic.timeline_ended
		player.can_move = false
		animation_player.play("fadeout_day_3")
		await animation_player.animation_finished
		player.can_move = true
		DayManager.go_to_next_day()
		GameManager.day_transitioning = false
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_forest_area_body_entered(body: Node2D) -> void:
	print("forest area entered")
	if not body.is_in_group("player"):
		return
	
	if can_go_to_forest:
		go_to_forest_last_day()
		return
		
	if not can_go_to_forest:
		world_label.text = "All animals have been saved today."
		
func _on_forest_area_body_exited(body: Node2D) -> void:
	if not can_go_to_forest:
		world_label.text = ""

func go_to_forest_last_day() -> void:
	await get_tree().process_frame
	#deactivate animal spawn, search for jitendra
	GameManager.last_day = true
	get_tree().change_scene_to_file("res://scenes/forest.tscn")
		
func setup_camera_limits() -> void:
	if not world_borders or not player_camera:
		push_warning("LevelLimits parent or Camera2D is not assigned in LevelManager.")
		return

	for child in world_borders.get_children():
		var shape: CollisionShape2D = child.get_node_or_null("CollisionShape2D") as CollisionShape2D
		var pos: Vector2 = shape.global_position if shape else child.global_position
		var col_shape: WorldBoundaryShape2D = shape.shape as WorldBoundaryShape2D
		var normal_direction: Vector2 = col_shape.normal
		if normal_direction == Vector2.RIGHT:
			player_camera.limit_left = int(pos.x)
		elif normal_direction == Vector2.LEFT:
			player_camera.limit_right = int(pos.x)
		elif normal_direction == Vector2.DOWN:
			player_camera.limit_top = int(pos.y)
		elif normal_direction == Vector2.UP:
			player_camera.limit_bottom = int(pos.y)
