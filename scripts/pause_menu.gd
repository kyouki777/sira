extends Control
@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
const SETTINGS_MENU = preload("res://scenes/settings_menu.tscn")

func _ready():
	# Ensure menu is hidden at start
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	play_button.pressed.connect(_on_resume_button_pressed)
	settings_button.pressed.connect(_on_setting_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		show_pause_menu()

func show_pause_menu():
	if get_tree().paused:
		return
	show()
	get_tree().paused = true

func _on_resume_button_pressed():
	hide()
	get_tree().paused = false

func _on_setting_button_pressed():
	get_tree().paused = true
	var setting_menu = SETTINGS_MENU.instantiate()
	get_parent().add_child(setting_menu)
	setting_menu.tree_exited.connect(_on_resume_button_pressed)

func _on_quit_button_pressed():
	hide()
	get_tree().paused = false
	get_tree().quit()   
