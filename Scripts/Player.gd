extends CharacterBody3D


@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var rotation_speed_x: float = 0.01
@export var rotation_speed_y: float = 0.01
@export var footstep_time: float = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3d
@onready var footstep_timer: Timer = $FootstepTimer
@onready var footstep_player: AudioStreamPlayer3D = $FootstepStreamPlayer3d

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * rotation_speed_x)
			camera.rotate_x(-event.relative.y * rotation_speed_y)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:  # Moving
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		if footstep_timer.is_stopped():
			footstep_player.pitch_scale = randf_range(0.8, 1.2)
			footstep_player.play()
			footstep_timer.start(footstep_time)
	else:  # Not moving
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
