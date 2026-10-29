extends Control

@onready var master_vol_slider: HSlider = %MasterVolSlider
@onready var mute_button: CheckBox = %MuteButton

func _ready() -> void:
	master_vol_slider.value = AudioServer.get_bus_volume_linear(0)
	mute_button.button_pressed = AudioServer.is_bus_mute(0)

func _on_exit_button_pressed() -> void:
	queue_free()

func _on_master_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

## Slider notes for copy paste references
# MinMax Value: 0.0 - 1.0
# Step: 0.05
# DON'T FORGET TO CONNECT THE SIGNALS
