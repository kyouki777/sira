extends Button
class_name ButtonPops

@export var targeted_scale:Vector2 = Vector2(1.2, 1.2)
@export var tween_time:float = 0.15

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pivot_offset_ratio = Vector2(0.5, 0.5)

func _on_mouse_entered():
	#AudioManager.play_sfx("hover_button")
	animate_pop(self, true)

func _on_mouse_exited():
	animate_pop(self, false)

func animate_pop(object:Control, is_hovering:bool):
	var tween:Tween = create_tween()
	if is_hovering:
		tween.tween_property(object, "scale", targeted_scale, tween_time)\
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(object, "scale", Vector2.ONE, tween_time)\
			.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
