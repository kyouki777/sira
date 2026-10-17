extends ColorRect

@onready var fade_timer: Timer = $"../../time_limit"

func _ready() -> void:
	fade_timer.one_shot = true # Ensures the timer doesn't restart automatically
	fade_out_view()

func _process(_delta: float) -> void:
	var screen_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	material.set_shader_parameter("mouse_position", mouse_pos / screen_size)
	material.set_shader_parameter("aspect_ratio", screen_size.x / screen_size.y)
	
	# If the timer is actively counting down, calculate smooth progress (0.0 -> 1.0)
	if not fade_timer.is_stopped():
		var progress: float = 1.0 - (fade_timer.time_left / fade_timer.wait_time)
		material.set_shader_parameter("fade_amount", progress)
	else:
		# If the timer has stopped/ended, clamp fade_amount at full opacity (1.0)
		material.set_shader_parameter("fade_amount", 1.0)

func fade_out_view() -> void:
	fade_timer.start(30.0)

func reveal_view() -> void:
	fade_timer.stop()
	material.set_shader_parameter("fade_amount", 0.0)
