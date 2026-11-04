extends Node2D

@onready var world_label: Label = $CanvasLayer/world_label
const FOREST = preload("uid://djsik0vi5b8k2")
@onready var world_borders: Node2D = $WorldBorders
var player_camera:Camera2D
@onready var player: CharacterBody2D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jitendra: StaticBody2D = $jitendra
@onready var orangutan: StaticBody2D = $orangutan

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var animal_sanctuary: Area2D = $animal_sanctuary
@onready var haze: ColorRect = $CanvasLayer2/haze
@onready var layer_3: TileMapLayer = $TileMap/layer3


func _ready() -> void:
	haze.visible = false
	layer_3.visible = false
	
	if not TimeManager.is_day_timer_running:
			TimeManager.start_day_timer(true)
	
	canvas_modulate.visible = false
	GameManager.player_in_village = false
	world_label.text = ""
	player_camera = player.camera_2d
	setup_camera_limits()
	
	if DayManager.current_day == 1:
		canvas_modulate.visible = true
		
	if GameManager.player_entered_forest == true:
		$Player.global_position = Vector2(560, 220)

	if DayManager.current_day == 2:
		haze.visible = true
		
	if DayManager.current_day == 3:
		jitendra.queue_free()
		orangutan.queue_free()
		layer_3.visible = true
	
func _process(delta: float) -> void:
	
	#day end logic
	if DayManager.has_all_animals_saved() and GameManager.day_transitioning == false:
		GameManager.day_transitioning = true
		print("transition day started")
		TimeManager.stop_day_timer()
		player.anim_sprite.stop()
		player.can_move = false #moves again when changing scenes
		animation_player.play("fadeout")
		await animation_player.animation_finished
		animal_sanctuary.clear_rescued_animals()
		get_tree().change_scene_to_file("res://scenes/day_end_transition.tscn")
		
	
func _on_forest_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if not GameManager.carrying_animal and not DayManager.has_all_animals_saved():
		go_to_forest()
	elif DayManager.has_all_animals_saved():
		world_label.text = "All animals have been saved today."
	else:
		world_label.text = "I need to put the injured animal in a safe place."

func go_to_forest():
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/forest.tscn")
	GameManager.player_entered_forest = true

func _on_forest_area_body_exited(_body: Node2D) -> void:
	world_label.text = ""

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


	
