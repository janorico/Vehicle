class_name Helicopter extends VehicleBase

var power: float = 0.0
var power_step: float = 4.0
var rotation_x_target: float = 0.0
var rotation_z_target: float = 0.0
var rotor_velocity: float = 0.0

onready var rotor = $Helicopter/Rotor

func _ready():
	if capturing:
		$XRotation.queue_free()
	power_min = -2
	power_max = 10

func initialize(id):
	.initialize(id)
	if not is_master:
		$XRotation.queue_free()

func _physics_process(delta):
	# Rotor
	rotor_velocity = move_toward(rotor_velocity, (power * 250), (delta * 100))
	rotor.rotation_degrees.y += rotor_velocity * delta
	apply_impulse(transform.basis.xform(Vector3(0, 2.6, 0)), transform.basis.xform(Vector3(0, power, 0)))
	# Rotation
	apply_torque_impulse(transform.basis.xform(Vector3((rotation_x_target * steer_limit), (steer_target * steer_limit), (rotation_z_target * steer_limit))))
	if steer_target < 0: $AnimationPlayer.play("Right")
	if steer_target > 0: $AnimationPlayer.play("Left")
	if steer_target == 0: $AnimationPlayer.stop()
	if is_master or Net.is_offline:
		# Change values (Only when enabled)
		if enabled:
			if input_type == InputType.KEYBOARD:
				rotation_x_target = Input.get_axis("accelerate_back", "accelerate")
				rotation_z_target = Input.get_axis("helicopter_z_left", "helicopter_z_right")
				if Input.is_action_pressed("power_up"):
					power += (power_step * delta)
				if Input.is_action_pressed("power_down"):
					power -= (power_step * delta)
				if Input.is_action_pressed("brake"):
					power = move_toward(power, 0, delta * power_step)
			elif input_type == InputType.MOUSE:
				rotation_z_target = Input.get_axis("mouse_helicopter_z_left", "mouse_helicopter_z_right")
				if Input.is_action_pressed("mouse_accelerate"):
					power += (power_step * delta)
				if Input.is_action_pressed("mouse_accelerate_back"):
					power -= (power_step * delta)
		power = clamp(power, power_min, power_max)
		$XRotation/Arrow.rect_rotation = (rotation_degrees.x * -1)
		if not Net.is_offline:
			rpc("update_helicopter", power, rotation_x_target, steer_target, rotation_z_target, rotor.rotation_degrees.y, rotor_velocity)


func get_pitch_scale() -> float:
	return range_lerp(power, power_min, power_max, 0.6, 1)


remote func update_helicopter(p: float, rot_x_t: float, rot_y_t: float, rot_z_t: float, rotor_deg: float, rotor_velo: float):
	power = p
	rotation_x_target = rot_x_t
	steer_target = rot_y_t
	rotation_z_target = rot_z_t
	rotor.rotation_degrees.y = rotor_deg
	rotor_velocity = rotor_velo

func _input(event):
	if input_type == InputType.MOUSE and event is InputEventMouseMotion:
		# X target
		var mouse_y = event.relative.y
		if mouse_y > 4:
			rotation_x_target = 1
		elif mouse_y < -4:
			rotation_x_target = -1
		else:
			rotation_x_target = 0

func get_power(): return power

# Override Light functions

remote func change_backward_light_energy(energy: float):
	return
	$BackwardLight.light_energy = energy

remote func change_light_energy(front_energy: float, back_energy: float):
	$LeftFrontLight.light_energy = front_energy
	$RightFrontLight.light_energy = front_energy
	return
	$LeftBackLight.light_energy = back_energy
	$RightBackLight.light_energy = back_energy

remote func change_light_range(front_range: float):
	$LeftFrontLight.spot_range = front_range
	$RightFrontLight.spot_range = front_range
