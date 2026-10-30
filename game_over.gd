extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2


func _ready() -> void:
	audio_stream_player_2.play()
	await get_tree().create_timer(2).timeout
	audio_stream_player.play()
	animation_player.play("fadein") #doesnt play for some reason

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	
	GameManager.reset_game()
	DayManager.reset_game()
	TimeManager.reset_game()
	
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
