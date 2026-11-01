extends Control

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

const SETTINGS_MENU = preload("res://scenes/settings_menu.tscn")

var current_settings_menu: Node = null

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	play_button.pressed.connect(_on_resume_button_pressed)
	settings_button.pressed.connect(_on_setting_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):

		if is_instance_valid(current_settings_menu):
			return
			
		if visible:
			_on_resume_button_pressed()
		else:
			show_pause_menu()

func show_pause_menu() -> void:
	show()
	get_tree().paused = true

func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_setting_button_pressed() -> void:
	if is_instance_valid(current_settings_menu):
		return
		
	get_tree().paused = true
	current_settings_menu = SETTINGS_MENU.instantiate()
	get_parent().add_child(current_settings_menu)
	

	#hide()

	# when settings menu is closed (queue_free'd) return to pause menu
	current_settings_menu.tree_exited.connect(_on_settings_closed)

func _on_settings_closed() -> void:
	current_settings_menu = null
	show() # show pause menu again

func _on_quit_button_pressed() -> void:
	hide()
	get_tree().paused = false
	get_tree().quit()
