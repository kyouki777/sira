extends CanvasLayer

@export var min_display_time: float = 0.0
@onready var click_overlay: Button = $click_overlay
@onready var tutorial_layer: CanvasLayer = $"."

var can_dismiss: bool = false

func _ready() -> void:

	if GameManager.tutorial_shown:
		queue_free()
		return
	
	get_tree().paused = true
	GameManager.tutorial_shown = true
	start_tutorial()

func _on_click_overlay_pressed() -> void:
	if not can_dismiss:
		print("Timer hasn't finished yet.")
		return 
	
	print("Dismissing tutorial now!")
	queue_free()
	get_tree().paused = false
	
func start_tutorial_timer() -> void: #time before the player can close the tutorial
	await get_tree().create_timer(min_display_time, true, false, true).timeout
	can_dismiss = true

func show_tutorial_UI(): #for adding more stuff like click to go next
	print("tutorial UI on") 
	tutorial_layer.visible = true
	
func start_tutorial(): #for starting condition in forest.gd
	start_tutorial_timer()
	show_tutorial_UI()
