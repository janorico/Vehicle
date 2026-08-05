class_name Helicopter extends VehicleBase
# Anti-torque (rudder / yaw): AD
# Cyclic (pitch, roll): WSQE
# Collective (up / down): JK
# Throttle (power): UI

var cyclic: Vector2
var anti_torque := 0.0
var collective := 0.0
var throttle := 0.0
var throttle_target := 0.0

export var rotate_speed = 1.0
export var rotate_force = 250.0

# Rotors
onready var rotor_hub = $Helicopter/RotorHub
onready var rotor = $Helicopter/RotorHub/Rotor
onready var rotor_tail = $Helicopter/SteeringRotor
# HUD
onready var altitude_label = $HUD/Misc/GridContainer/Altitude
onready var vspeed_label = $HUD/Misc/GridContainer/VSpeed
onready var hspeed_label = $HUD/Misc/GridContainer/HSpeed
onready var throttle_grip = $HUD/Throttle/Grip
onready var throttle_label = $HUD/Throttle/Grip/Label
onready var x_rot_arr = $HUD/XRotation/Arrow

func _ready():
	if capturing:
		$HUD.queue_free()
	power_min = 0
	power_max = 1

func initialize(id):
	.initialize(id)
	if not is_master:
		$HUD.queue_free()

func _physics_process(delta):
	if is_master or Net.is_offline:
		# Change values (Only when enabled)
		if enabled:
			cyclic = cyclic.move_toward(Input.get_vector("accelerate_back", "accelerate", "roll_left", "roll_right"), delta * 5)
			anti_torque = move_toward(anti_torque, Input.get_axis("steer_right", "steer_left"), delta * 5)
			if Input.is_action_pressed("brake"):
				collective = move_toward(collective, 0.0, delta * 2)
			else:
				collective = clamp(collective + Input.get_axis("collective_down", "collective_up") * delta * 0.5, power_min, power_max)
			throttle_target = clamp(throttle_target + Input.get_axis("throttle_down", "throttle_up") * delta * 0.5, power_min, power_max)
			throttle = move_toward(throttle, throttle_target, delta * 0.1)
			# Update HUD
			var hud_form_str = "%5.1f %s"
			altitude_label.text = hud_form_str % [ translation.y, "m" ]
			vspeed_label.text = hud_form_str % [ linear_velocity.y, "m/s" ]
			hspeed_label.text = hud_form_str % [ Vector2(linear_velocity.x, linear_velocity.z).length(), "m/s" ]
			throttle_grip.margin_top = (1 - collective) * 80
			throttle_label.text = "%.1f%%" % (collective * 100)
			x_rot_arr.rect_rotation = (rotation_degrees.x * -1)
		if not Net.is_offline:
			rpc("update_helicopter", cyclic, collective, throttle)
	# Visual
	rotor_hub.rotation_degrees = Vector3(cyclic.x, 0, cyclic.y) * 3
	var rotor_d = TAU * throttle * delta # TAU (1 rotation) * amount of throttle * delta time
	rotor.rotation.y += rotor_d * 7 # 7 RPS * 60 s = 420 RPM
	rotor_tail.rotation.x += rotor_d * 50 # 50 RPS * 60 s = 3000 RPM
	# Physics
	add_force(global_transform.basis.y * throttle * collective * 750, transform.basis.xform(rotor_hub.position))
	var target_dir = transform.basis.xform(Vector3(cyclic.x, anti_torque, cyclic.y))
	var target_velocity = target_dir * rotate_speed
	var diff = target_velocity - angular_velocity
	var multiplier = smoothstep(0.0, rotate_speed, diff.length()) * 0.8 + 0.2
	add_torque(rotate_force * diff.normalized() * multiplier * throttle)


func get_pitch_scale() -> float:
	return range_lerp(throttle, power_min, power_max, 0.6, 1)


remote func update_helicopter(p_cyclic: Vector2, p_collective: float, p_throttle: float):
	cyclic = p_cyclic
	collective = p_collective
	throttle = p_throttle

func get_power(): return throttle

func get_power_target(): return throttle_target

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
