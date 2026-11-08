extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var black_overlay: ColorRect = $black_overlay


func _ready() -> void:
	black_overlay.visible = true
	audio_stream_player_2.play()
	await get_tree().create_timer(2).timeout
	audio_stream_player.play()
	animation_player.play("fadein")

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	if not GameManager.last_day:
		GameManager.reset_game()
		DayManager.reset_game()
		TimeManager.reset_game()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/day_end_transition.tscn")
