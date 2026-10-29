extends CharacterBody2D

@export var walk_speed = 100.0
@export var footstep_interval: float = 0.35 

var input_dir = Vector2.ZERO
var last_dir : Vector2
var last_anim_direction: String = "down"
var footstep_timer: float = 0.0

@export var anim_sprite : AnimatedSprite2D
@onready var saved_animal: Sprite2D = %SavedAnimal
@onready var camera_2d: Camera2D = $Camera2D
@onready var footstep_sfx: AudioStreamPlayer2D = $FootstepSFX

var can_move : bool = true

var current_interactable : Interactable = null


func _ready() -> void:
	$AnimatedSprite2D.play("idle_down")
	
	Dialogic.timeline_started.connect(_on_dialogic_timeline_started)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	
	if GameManager.carrying_animal:
		saved_animal.texture = GameManager.current_carried_texture

func _physics_process(delta: float) -> void:
	if can_move == true:
		player_movement()
		player_animation()
		handle_footsteps()
		move_and_slide()
	else:
		if footstep_sfx.playing:
			footstep_sfx.stop()

func player_movement():
	input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * walk_speed
	last_dir = input_dir
	update_animation(input_dir)

func handle_footsteps() -> void:
	if input_dir != Vector2.ZERO:
		if not footstep_sfx.playing:
			footstep_sfx.play()
	else:
		if footstep_sfx.playing:
			footstep_sfx.stop()

func play_footstep() -> void:
	if footstep_sfx and footstep_sfx.stream:
		
		footstep_sfx.pitch_scale = randf_range(0.88, 1.12)
		footstep_sfx.play()

func player_animation():
	if input_dir == Vector2.ZERO:
		$AnimatedSprite2D.stop()
		return

	if abs(input_dir.x) > abs(input_dir.y):
		if input_dir.x < 0:
			$AnimatedSprite2D.play("walk_left")
		else:
			$AnimatedSprite2D.play("walk_right")
	else:
		if input_dir.y < 0:
			$AnimatedSprite2D.play("walk_up")
		else:
			$AnimatedSprite2D.play("walk_down")

func update_animation(direction: Vector2):
	var anim_to_play: String = ""
	var new_anim_direction: String = last_anim_direction

	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			new_anim_direction = "right" if direction.x > 0 else "left"
		else:
			new_anim_direction = "down" if direction.y > 0 else "up"

		anim_to_play = "walk_" + new_anim_direction
		last_anim_direction = new_anim_direction
	else:
		anim_to_play = "idle_" + last_anim_direction

	if anim_sprite.animation != anim_to_play:
		anim_sprite.play(anim_to_play)

func drop_animal():
	saved_animal.texture = null

func _on_dialogic_timeline_started() -> void:
	can_move = false
	velocity = Vector2.ZERO
	input_dir = Vector2.ZERO
	footstep_timer = 0.0
	set_process_unhandled_input(false)
	
	if anim_sprite:
		anim_sprite.play("idle_" + last_anim_direction)
		
	print("dialogic playing. player cant move")

func _on_dialogic_timeline_ended() -> void:
	can_move = true
	set_process_unhandled_input(true)
	print("dialogic stopped. player can move")

func player_camera_on():
	camera_2d.enabled = true
	print("players camera on")

func player_camera_off():
	camera_2d.enabled = false
	print("players camera off")

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and current_interactable:
		current_interactable.interact()

func _on_interaction_area_area_entered(area: Area2D) -> void:
	print("interaction area entered")
	if area is Interactable:
		current_interactable = area

func _on_interaction_area_area_exited(area: Area2D) -> void:
	print("interaction area exited")
	if area is Interactable:
		if current_interactable == area:
			current_interactable = null
