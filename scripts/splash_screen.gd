extends Control

@export var logo: Texture2D
@export_file("*.tscn") var main_menu_scene: String
@export var fade_duration: float = 0.6
@export var display_duration: float = 1.8

@onready var logo_texture: TextureRect = $LogoTexture

var tween: Tween

func _ready() -> void:
	if not logo or main_menu_scene == "":
		_change_to_main_menu()
		return
		
	_play_splash()

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_pressed() and not event.is_echo():
		_change_to_main_menu()

func _play_splash() -> void:
	logo_texture.texture = logo
	logo_texture.modulate.a = 0.0

	tween = create_tween()
	
	tween.tween_property(logo_texture, "modulate:a", 1.0, fade_duration)
	
	tween.tween_interval(display_duration)
	
	tween.tween_property(logo_texture, "modulate:a", 0.0, fade_duration)
	
	tween.tween_callback(_change_to_main_menu)

func _change_to_main_menu() -> void:
	if tween and tween.is_running():
		tween.kill()
	get_tree().change_scene_to_file(main_menu_scene)
