extends TextureProgressBar

func _ready() -> void:
	TimeManager.day_timer_updated.connect(update_time_value)

func update_time_value(remaining_time:float):
	value = (remaining_time / DayManager.day_total_time) * max_value
