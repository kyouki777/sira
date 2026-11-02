extends Label

var has_shown_self:bool = false
@export var show_up_time:float = 0.15
@export var hide_down_time:float = 0.2

func _ready() -> void:
	self_modulate.a = 1.0
	visible_ratio = 0.0

func show_up():
	var tween:Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "visible_ratio", 1.0, show_up_time)
	tween.tween_callback(func(): has_shown_self = true)

func hide_down():
	var tween:Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "self_modulate:a", 0.0, hide_down_time)

func _unhandled_input(event: InputEvent) -> void:
	if has_shown_self:
		if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down"):
			hide_down()
