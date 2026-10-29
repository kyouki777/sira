extends Control

const SETTINGS_MENU = preload("res://scenes/settings_menu.tscn")

func _ready() -> void:
	$CenterContainer/VBoxContainer/PlayButton.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/village.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	var setting_menu = SETTINGS_MENU.instantiate()
	add_child(setting_menu)
