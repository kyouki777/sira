extends StaticBody2D

var talked_to_jitendra: bool = false

var current_dialogue_index: int = 0

@onready var interactable: Interactable = $Area2D

@export var ordered_timelines: Array[String] = [
	"jitendra1_village", 
	"jitendra2_village",
	"jitendra_option" 
]

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)

func _on_interacted() -> void:
	if ordered_timelines.is_empty():
		return
		
	var chosen_timeline: String = ordered_timelines[current_dialogue_index]
	
	Dialogic.start(chosen_timeline)
	if current_dialogue_index == 2:
		talked_to_jitendra = true
		print("jitendra all dialogue option finished")
	
	if current_dialogue_index < ordered_timelines.size() - 1:
		current_dialogue_index += 1
