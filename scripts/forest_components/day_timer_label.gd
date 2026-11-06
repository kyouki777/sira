extends Label

func _ready() -> void:
	update_time_value(DayManager.day_total_time - TimeManager.current_day_time)
	TimeManager.day_timer_updated.connect(update_time_value)

func update_time_value(remaining_time:float):
	text = str(ceili(remaining_time))
