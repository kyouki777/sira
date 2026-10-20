extends TextureProgressBar

@export var timer_node:Timer

func _ready() -> void:
	if not is_instance_valid(timer_node):
		push_error("Timer belum dipasang ke Oxygen Meter!")
		return
	value = max_value

func _process(_delta: float) -> void:
	#Change value based on time_limit
	var current_time:float = timer_node.time_left
	var max_time:float = timer_node.wait_time
	value = ceili(max_value * current_time / max_time)
