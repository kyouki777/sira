extends ColorRect

@export var time: float = 0.3

var tween: Tween

func _ready() -> void:
	material = material.duplicate()

func start_effect() -> void:
	_animate_progress(1.0)

func end_effect() -> void:
	_animate_progress(0.0)

func _animate_progress(target: float) -> void:
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.tween_method(
		_set_progress,
		_get_progress(),
		target,
		time
	)

func _get_progress() -> float:
	var mat := material as ShaderMaterial
	if mat:
		return mat.get_shader_parameter("progress")
	return 0.0

func _set_progress(value: float) -> void:
	var mat := material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("progress", value)
