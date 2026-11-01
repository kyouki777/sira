extends Node

@export var data_days: Array[DayData] = []
var current_day_data: DayData
var current_day: int = 1
var current_animals_saved: int = 0

var day_number: int = 1
var day_total_time: float = 120.0
var day_target_animal: int = 5
var day_oxygen_limit: float = 30.0
var day_branch_fall_time_range: Array[int] = []

func _ready() -> void:
	current_day = 1
	if data_days.is_empty():
		push_error("Data day belum masuk!")
		return
	current_day_data = data_days[current_day - 1]
	await load_variable_from_days()
	TimeManager.stop_day_timer()

# Panggil pas ganti hari
func go_to_next_day() -> void:
	current_day += 1
	print("day changing: ", current_day)
	if current_day > data_days.size() or not data_days[current_day - 1]:
		push_error("Data day hari %s belum ada", [current_day])
		return
		
	current_animals_saved = 0 # Reset saved animals for the new day
	current_day_data = data_days[current_day - 1]
	load_variable_from_days()
	TimeManager.reset_day_timer()
	TimeManager.stop_day_timer()

func has_all_animals_saved() -> bool:
	return current_animals_saved >= day_target_animal

func load_variable_from_days() -> void:
	day_number = current_day_data.day_number
	day_total_time = current_day_data.day_total_time
	day_target_animal = current_day_data.day_target_animal
	day_oxygen_limit = current_day_data.day_oxygen_limit
	day_branch_fall_time_range = current_day_data.day_branch_fall_time_range
	TimeManager.start_day_timer()

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
