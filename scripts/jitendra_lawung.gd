extends TextureButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if not GameManager.jitendra_lawung_spawned:
		audio_stream_player.play()
		GameManager.jitendra_lawung_spawned = true

func _on_pressed() -> void:
	
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
	print("ending started")
	TimeManager.stop_day_timer()
