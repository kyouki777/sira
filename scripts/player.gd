
extends CharacterBody2D

@export var walk_speed = 100.0
var input_dir = Vector2.ZERO
var last_dir : Vector2
var last_anim_direction: String = "Down"
@export var anim_sprite : AnimatedSprite2D

func _ready() -> void:
	$AnimatedSprite2D.play("idle_down")

func _physics_process(delta: float) -> void:
	player_movement()
	player_animation()
	move_and_slide()

func player_movement():

	input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * walk_speed
	last_dir = input_dir
	update_animation(input_dir)
	
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
		# Determine whether the player is moving
		# horizontally or vertically
		if abs(direction.x) > abs(direction.y):
			new_anim_direction = "right" if direction.x > 0 else "left"
		else:
			new_anim_direction = "down" if direction.y > 0 else "up"

		# Walking animation
		anim_to_play = new_anim_direction

		# Remember the direction
		last_anim_direction = new_anim_direction

	else:
		# Idle animation
		anim_to_play = "idle_" + last_anim_direction

	# Only change animation if necessary
	if anim_sprite.animation != anim_to_play:
		anim_sprite.play(anim_to_play)
		
