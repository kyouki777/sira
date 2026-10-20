extends TextureButton

var animal_scene: PackedScene 
signal saved_animal_texture(texture:Texture2D)

func _on_pressed() -> void:
	if animal_scene:
		GameManager.current_carried_scene = animal_scene
		GameManager.current_carried_texture = texture_normal
		GameManager.carrying_animal = true
		print("Carrying animal: ", animal_scene.resource_path)
	else:
		push_warning("animal_scene is not assigned on this button!")
	
	saved_animal_texture.emit(texture_normal)
	# Safely delete the animal instance
	if owner and owner != get_tree().current_scene:
		owner.queue_free()
	else:
		queue_free()
