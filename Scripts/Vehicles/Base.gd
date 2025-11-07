class_name VehicleBase extends VehicleBody

enum CameraType {
	WINDSCREEN = 0,
	LEFT = 1,
	RIGHT = 2,
	CENTER = 3,
	INTERPOLATED_CAMERA = 4,
	FOLLOW_CAMERA = 5
}

enum InputType {
	KEYBOARD = 0,
	MOUSE = 1,
	#SERIAL_PORT = 2
}
# Power
var power_min = -100
var power_max = 100
# Camera options
export(CameraType) var camera := CameraType.INTERPOLATED_CAMERA
var light := false
# Light options
export(float, 0.0, 16.0) var front_light_energy := 16.0
export(float, 0.0, 16.0) var back_light_energy := 6.0
export(float, 0.0, 16.0) var backward_light_energy := 10.0
export(float, 20.0, 100.0) var front_light_range_low_beam := 40.0
export(float, 20.0, 100.0) var front_light_range_high_beam := 100.0
# Multiplayer data
var is_master = false
var player_id = null
# Values to reset on pressing 'CTRL+Home'.
onready var start_translation = get_translation()
onready var start_rotation = get_rotation_degrees()
# Steer options
export(float) var steer_speed := 1.5
export(float) var steer_limit := 0.4
var steer_target := 0.0
# Engine force and brake options
export(float, 20.0, 100.0) var engine_force_value: float = 40.0 setget set_engine_force_value
export(float) var brake_value := 1.0
# Control (Keyboard/Mouse/Serial port)
var input_type = InputType.KEYBOARD
var enabled: bool = true
# Only for capturing
var capturing := false
# Other
var local_velocity := Vector3.ZERO

func _ready():
	if Net.is_offline:
		camera = Global.last_used_view
		update_camera()
	if capturing:
		$EngineSound.stop()
		enabled = false
		mode = RigidBody.MODE_STATIC

func _physics_process(_delta):
	$EngineSound.pitch_scale = get_pitch_scale()
	if not (is_master or Net.is_offline) or not enabled:
		return
	local_velocity = transform.basis.xform_inv(linear_velocity)
	if input_type == InputType.KEYBOARD:
		steer_target = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	if Input.is_action_just_released("reset"):
		translation = start_translation
		rotation_degrees = start_rotation
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		sleeping = false
	if not Net.is_offline:
		rpc("update_all", translation, rotation_degrees, steering, engine_force, brake)

func _input(event):
	if input_type == InputType.MOUSE and event is InputEventMouseMotion:
		steer_target += Global.inverse(event.relative.x * 0.001)


func get_pitch_scale() -> float:
	return 1.0


func set_engine_force_value(value: float):
	engine_force_value = value

func initialize(id):
	is_master = id == Net.net_id
	player_id = id
	if is_master:
		camera = Global.last_used_view
		update_camera()
		$NameLabel3D.queue_free()
	else:
		$WindscreenCamera.queue_free()
		$LeftCamera.queue_free()
		$RightCamera.queue_free()
		$CenterCamera.queue_free()
		get_node("../InterpolatedCamera").queue_free()

func set_player_name(player_name: String):
	$NameLabel3D.show()
	$NameLabel3D.text = player_name

remote func update_all(pos, rot, s, ef, b):
	translation = pos
	rotation_degrees = rot
	steering = s
	engine_force = ef
	brake = b

func control_with_keyboard():
	steer_target = 0
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	input_type = InputType.KEYBOARD

func control_with_mouse():
	steer_target = 0
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	input_type = InputType.MOUSE

func set_view(view: int):
	camera = view
	update_camera()
	Global.last_used_view = camera
	Global.save_last_states()

func update_camera():
	match camera:
		CameraType.LEFT: $LeftCamera.make_current()
		CameraType.RIGHT: $RightCamera.make_current()
		CameraType.CENTER: $CenterCamera.make_current()
		CameraType.WINDSCREEN: $WindscreenCamera.make_current()
		CameraType.INTERPOLATED_CAMERA: get_node("../InterpolatedCamera").make_current()
		CameraType.FOLLOW_CAMERA: $FollowCamera.make_current()

func no_beam():
	update_light_energy(false)
	light = false

func low_beam():
	update_light_energy(true)
	update_light_range(front_light_range_low_beam)
	light = true

func high_beam():
	update_light_energy(true)
	update_light_range(front_light_range_high_beam)
	light = true

func update_backward_light_energy(on: bool):
	var energy := 0.0
	if on: energy = backward_light_energy
	change_backward_light_energy(energy)
	if not Net.is_offline:
		rpc("change_backward_light_energy", energy)

func update_light_energy(on: bool):
	var front_energy := 0.0
	var back_energy := 0.0
	if on:
		front_energy = front_light_energy
		back_energy = back_light_energy
	# Applying changes
	change_light_energy(front_energy, back_energy)
	if not Net.is_offline:
		rpc("change_light_energy", front_energy, back_energy)

func update_light_range(front_range: float):
	change_light_range(front_range)
	if not Net.is_offline:
		rpc("change_light_range", front_range)

remote func change_backward_light_energy(energy: float):
	$BackwardLight.light_energy = energy

remote func change_light_energy(front_energy: float, back_energy: float):
	$LeftFrontLight.light_energy = front_energy
	$RightFrontLight.light_energy = front_energy
	$LeftBackLight.light_energy = back_energy
	$RightBackLight.light_energy = back_energy

remote func change_light_range(front_range: float):
	$LeftFrontLight.spot_range = front_range
	$RightFrontLight.spot_range = front_range

func _crash(_body):
	play_crash_sound()
	if not Net.is_offline and is_master:
		rpc("play_crash_sound")

remote func play_crash_sound():
	$CrashSound.play()
