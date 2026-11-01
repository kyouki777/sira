extends Label

func _ready() -> void:
	update_animal_counter()

func _process(delta: float) -> void:
	update_animal_counter()
	
func update_animal_counter():
	text = "%s / %s" % [DayManager.current_animals_saved, DayManager.day_target_animal]
