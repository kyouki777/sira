extends Node

signal day_timer_updated(current_time: float)

var total_playtime: float = 0.0
var current_day_time: float = 0.0

var is_total_timer_running: bool = false
var is_day_timer_running: bool = false

#func _ready() -> void:
	#start_day_timer()

func _process(delta: float) -> void:
	if is_total_timer_running:
		total_playtime += delta
		
	if is_day_timer_running:
		current_day_time += delta
		if current_day_time < DayManager.day_total_time:
			day_timer_updated.emit(DayManager.day_total_time - current_day_time)
		else:
			# Call Gameover here
			stop_day_timer()
			day_timer_updated.emit(0)

func time_penalty(penalty_time:float = 3.0):
	current_day_time += penalty_time

func start_day_timer(reset: bool = true) -> void:
	if reset:
		current_day_time = 0.0
	is_day_timer_running = true
	start_total_timer()

func stop_day_timer() -> void:
	is_day_timer_running = false
	stop_total_timer()

func reset_day_timer() -> void:
	current_day_time = 0.0

func start_total_timer() -> void:
	is_total_timer_running = true

func stop_total_timer() -> void:
	is_total_timer_running = false
	
func reset_game() -> void:
	total_playtime = 0.0
	current_day_time = 0.0
	is_day_timer_running = false
	is_total_timer_running = false
