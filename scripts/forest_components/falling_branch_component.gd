extends Node2D

signal dead_by_falling_branch

@export var warning_time:float = 2.0
@export var branch_fall_time:float = 3.0
@export var forest: Node2D
@onready var warning_sprite: Sprite2D = %WarningSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var warning_timer: Timer = %WarningTimer
@onready var till_branch_fall_timer: Timer = %TillBranchFallTimer
@onready var branch: Area2D = %Branch

func _ready() -> void:
	warning_sprite.hide()
	warning_sprite.modulate = Color.WHITE
	var seconds_until_branch_fall:int = DayManager.get_random_branch_falltime()
	if seconds_until_branch_fall == -1:
		print("No branch fall today")
		#queue_free()
		return
	till_branch_fall_timer.wait_time = seconds_until_branch_fall
	till_branch_fall_timer.timeout.connect(start_warning_sequence)
	till_branch_fall_timer.start()
	warning_timer.wait_time = warning_time
	warning_timer.timeout.connect(start_branch_fall_sequence)

func start_warning_sequence():
	warning_sprite.show()
	animation_player.play("flashing")
	warning_timer.start()
	forest.set_process_input(false)

func start_branch_fall_sequence():
	warning_sprite.hide()
	var tween:Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(branch, "position", Vector2.ZERO, branch_fall_time)
	tween.tween_callback(branch_fallen_on_player)

func branch_fallen_on_player():
	# sprite sira dead kalo ada
	var sira:Sprite2D = get_parent() as Sprite2D
	sira.self_modulate = Color.RED
	dead_by_falling_branch.emit()
	print("Dead by branch fall")

func _on_branch_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Add branch destroyed sprite here as sibling but keep this component die
		queue_free()
		forest.set_process_input(false)
