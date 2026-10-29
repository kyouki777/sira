extends Node2D

@onready var world_label: Label = $CanvasLayer/world_label
const FOREST = preload("uid://djsik0vi5b8k2")
@onready var world_borders: Node2D = $WorldBorders
var player_camera:Camera2D
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_label.text = ""
	player_camera = player.camera_2d
	setup_camera_limits()

func _on_forest_area_body_entered(_body: Node2D) -> void:
	if GameManager.carrying_animal == false and not DayManager.has_all_animals_saved():
		go_to_forest()
	elif DayManager.has_all_animals_saved():
		world_label.text = "All animals have been saved today."
	else:
		world_label.text = "I need to put the injured animal in a safe place."

func go_to_forest():
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/forest.tscn")

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
