extends Node

@export var data_days:Array[DayData] = []
var current_day_data:DayData
var current_day:int = 1
var current_animals_saved:int = 0

var day_number:int = 1
var day_total_time:float = 120.0
var day_target_animal:int = 5
var day_oxygen_limit:float = 30.0
var day_branch_fall_time_range:Array[int] = []

func _ready() -> void:
	current_day = 1
	if data_days.is_empty():
		push_error("Data day belum masuk!")
		return
	current_day_data = data_days[current_day - 1]
	load_variable_from_days()

func go_to_next_day():
	current_day += 1
	if not data_days[current_day - 1]:
		push_error("Data day hari %s belum ada", [current_day])
		return
	current_day_data = data_days[current_day - 1]
	load_variable_from_days()

func has_all_animals_saved() -> bool:
	return true if current_animals_saved == day_target_animal else false

func load_variable_from_days():
	day_number = current_day_data.day_number
	day_total_time = current_day_data.day_total_time
	day_target_animal = current_day_data.day_target_animal
	day_oxygen_limit = current_day_data.day_oxygen_limit
	day_branch_fall_time_range = current_day_data.day_branch_fall_time_range
	TimeManager.reset_day_timer()

func get_random_branch_falltime() -> int:
	if day_branch_fall_time_range.is_empty():
		return -1
	else:
		return randi_range(day_branch_fall_time_range[0], day_branch_fall_time_range[1])
		
func reset_game() -> void:
	current_day = 1
	current_animals_saved = 0
	
	if not data_days.is_empty():
		current_day_data = data_days[0]
		load_variable_from_days()
