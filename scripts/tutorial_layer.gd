extends CanvasLayer

@export var tutorial_images:Array[Texture2D] = []
@onready var click_overlay: Button = $click_overlay
@onready var tutorial_layer: CanvasLayer = $"."
@onready var tutorial_image_node: TextureRect = %TutorialImage

var can_dismiss: bool = false

func _ready() -> void:
	if GameManager.tutorial_shown:
		queue_free()
		return
	
	get_tree().paused = true
	GameManager.tutorial_shown = true
	start_tutorial()

func _on_click_overlay_pressed() -> void:
	if tutorial_images:
		tutorial_image_node.texture = tutorial_images.pop_front()
	else:
		print("Dismissing tutorial now!")
		queue_free()
		get_tree().paused = false

func show_tutorial_UI():
	print("tutorial UI on") 
	tutorial_layer.visible = true

func start_tutorial():
	show_tutorial_UI()
	if tutorial_images.is_empty():
		push_error("Tutorial images belum dipasang!")
		return
	tutorial_image_node.texture = tutorial_images.pop_front()
