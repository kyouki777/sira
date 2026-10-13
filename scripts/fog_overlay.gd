extends ColorRect

@export var fade_duration: float = 20.0 # Duration of the fade out in seconds

func _ready() -> void:
	fade_out_view()
func _process(_delta: float) -> void:
	var screen_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	material.set_shader_parameter("mouse_position", mouse_pos / screen_size)
	material.set_shader_parameter("aspect_ratio", screen_size.x / screen_size.y)

# Call this to smoothly fade the revealed circle view back into fog
func fade_out_view() -> void:
	var tween = create_tween()
	# Transition 'fade_amount' from 0.0 to 1.0
	tween.tween_property(material, "shader_parameter/fade_amount", 1.0, fade_duration)

# Call this to reopen/reveal the clear view again
func reveal_view() -> void:
	var tween = create_tween()
	# Transition 'fade_amount' back to 0.0
	tween.tween_property(material, "shader_parameter/fade_amount", 0.0, 0.5)
