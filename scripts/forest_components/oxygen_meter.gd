extends TextureProgressBar

@export var timer_node: Timer
@export var extra_time_duration: float = 60.0
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"	

var extra_time_left: float = 60.0

func _ready() -> void:
	if not is_instance_valid(timer_node):
		push_error("Timer belum dipasang ke Oxygen Meter!")
		return
	value = max_value
	extra_time_left = extra_time_duration

func _process(delta: float) -> void:
	if not is_instance_valid(timer_node):
		return

	var current_time: float = timer_node.time_left
	var max_time: float = timer_node.wait_time

	if GameManager.last_day and current_time <= 0.0:
		# so that the bar stays stuck at 0 while 15 seconds count down in background
		extra_time_left = maxf(0.0, extra_time_left - delta)
		value = 0
		animation_player.play("last_breath")
		
		# optional: check if overtime is up
		if extra_time_left <= 0.0:
			# trigger end condition (e.g., GameManager.end_game())
			animation_player.stop()
			print("gameover: oxygen last day ran out")
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		value = ceili(max_value * current_time / max_time)
