extends Node2D

@onready var animal_marker: Marker2D = $"../animal_spawn_point"
@onready var world_label: Label = $"../CanvasLayer/world_label"

# Set these in the Inspector to match the pixel art grid
@export var tile_size: Vector2 = Vector2(32, 32) # Pixel width/height of your grid tiles
@export var columns: int = 4
@export var player_node:CharacterBody2D
var is_player_inside: bool = false

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	display_rescued_animals()

func _process(_delta: float) -> void:
	# Check input continuously while the player is inside the area
	if is_player_inside and Input.is_action_just_pressed("interact"):
		if GameManager.carrying_animal and GameManager.current_carried_scene:
			audio_stream_player.play()
			GameManager.add_rescued_animal(GameManager.current_carried_scene)
			print("Animal deposited into sanctuary!")
			display_rescued_animals()
			GameManager.carrying_animal = false
			if player_node.has_method("drop_animal"):
				player_node.drop_animal()
			DayManager.current_animals_saved += 1
			world_label.text = ""
			# Check udh semua animal atau belum, kalau udh go to next sequence
			
func display_rescued_animals() -> void:
	if not animal_marker:
		return

	# Delete existing instances immediately instead of queuing
	for child in animal_marker.get_children():
		child.free()

	for i in range(GameManager.rescued_animals.size()):
		var animal_scene: PackedScene = GameManager.rescued_animals[i]
		if animal_scene:
			var instance = animal_scene.instantiate()

			# Calculate offset relative to Marker2D
			var col: int = i % columns
			var row: int = i / columns
			instance.position = Vector2(col * tile_size.x, row * tile_size.y)

			# Ensure node and all children are visible
			instance.visible = true
			
			# Disable button interactions for the sanctuary instance
			_disable_animal_buttons(instance)
			
			# Add as child of Marker2D
			animal_marker.add_child(instance)
			
func clear_rescued_animals() -> void:
	print("animals in sanctuary cleared")
	if animal_marker:
		for child in animal_marker.get_children():
			child.free()
			
	if "rescued_animals" in GameManager:
		GameManager.rescued_animals.clear()
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body is CharacterBody2D:
		print("Player entered sanctuary area")
		is_player_inside = true
		if GameManager.carrying_animal == true:
			world_label.text = "Press E to put down animal"

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") or body is CharacterBody2D:
		print("Player exited sanctuary area")
		is_player_inside = false
		world_label.text = ""
		
func _disable_animal_buttons(node: Node) -> void:
	# If the root of the animal scene is a Button/Control
	if node is BaseButton:
		node.disabled = true
		node.focus_mode = Control.FOCUS_NONE
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
