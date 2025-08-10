class_name Vehicle extends VehicleBase

var handbrake := false
var backward_light_on := false
#const SERCOMM = preload("res://bin/GDsercomm.gdns")
#onready var port = SERCOMM.new()
onready var horn_sound: AudioStreamPlayer3D = $HornSound
export var engine_sound_min_pitch_scale := 0.9
export var engine_sound_max_pitch_scale := 1.1


func _ready():
	if OS.is_debug_build() and capturing:
		$Smoke.emitting = false
		$LeftMirror.queue_free()
		$RightMirror.queue_free()
		$RightMirrorPlaceHolder.queue_free()
		$LeftMirrorPlaceHolder.queue_free()


func initialize(id):
	.initialize(id)
	if not is_master:
		$RightMirror.queue_free()
		$RightMirrorPlaceHolder.queue_free()
		$LeftMirror.queue_free()
		$LeftMirrorPlaceHolder.queue_free()


func _physics_process(delta):
	if (is_master or Net.is_offline) and enabled:
		if input_type == InputType.KEYBOARD:
			# Handbrake
			if Input.is_action_just_released("handbrake"):
				handbrake = not handbrake
				get_node("../..").handbrake_toggled(handbrake)
			process_input(Input.get_axis("accelerate_back", "accelerate"), Input.get_axis("steer_right", "steer_left"), Input.get_action_strength("brake"), delta)
		elif input_type == InputType.MOUSE:
			process_input(Input.get_axis("mouse_accelerate_back", "mouse_accelerate"), steer_target, Input.get_action_strength("mouse_brake"), null)
		#elif input_type == InputType.SERIAL_PORT:
		#	var input = ""
		#	if port.get_available() > 0:
		#		for _i in range(port.get_available()):
		#			var part = String(port.read())
		#			input = String.join([input, part])
		#	input = input.split(";")
		#	if input.size() == 4:
		#		# Steering
		#		var steering_input = float(input[0])
		#		if steering_input >= -1 and steering_input <= 1:
		#			steering = steering_input * steer_limit
		#		# Engine force
		#		var engine_force_input = float(input[1])
		#		var backward_input = int(input[2])
		#		if engine_force_input > 0.0 and engine_force_input <= 1.0:
#		#			accelerate(engine_force_value * engine_force_input)
		#			if backward_input == 1:
		#				engine_force = -engine_force
		#		else:
		#			engine_force = 0
		#		# Brake
		#		var brake_input = int(input[3])
		else:
			steer_target = 0
			engine_force = 0
			brake = 0
		# Backward light
		if engine_force < 0.0 and backward_light_on == false and light == true:
			update_backward_light_energy(true)
			backward_light_on = true
		if engine_force > 0.0 and backward_light_on == true:
			update_backward_light_energy(false)
			backward_light_on = false
		# Horn
		if Input.is_action_pressed("horn"):
			if not horn_sound.playing:
				horn_sound.play()
				if not Net.is_offline:
					rpc("update_horn", true)
		elif horn_sound.playing:
			horn_sound.stop()
			if not Net.is_offline:
				rpc("update_horn", false)


func get_pitch_scale() -> float:
	return range_lerp(abs(engine_force), 0, engine_force_value, engine_sound_min_pitch_scale, engine_sound_max_pitch_scale)


func control_with_mouse():
	.control_with_mouse()
	#port.close()

func control_with_keyboard():
	.control_with_keyboard()
	#port.close()

#func control_with_serial_port(port_name):
#	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	if port_name != null:
#		set_physics_process(false)
#		port.close()
#		port.open(port_name, 2000000, 1000)
#		input_type = InputType.SERIAL_PORT
#		set_physics_process(true)


#func get_ports():
#	return port.list_ports()


func set_engine_force_value(value):
	.set_engine_force_value(value)
	power_max = engine_force_value * 2.5
	power_min = -power_max


func get_power(): return engine_force


remote func update_horn(horning: bool):
	if horning:
		if not horn_sound.playing:
			horn_sound.play()
	elif horn_sound.playing:
		horn_sound.stop()


func process_input(engine_force_input: float, steer_input: float, brake_input: float, delta):
	var speed = local_velocity.z
	if delta:
		steering = move_toward(steering, steer_input * steer_limit, steer_speed * delta)
	else:
		steering = clamp(steer_target, -steer_limit, steer_limit)
	if handbrake:
		brake_input = 1.0
	if brake_input == 0.0:
		brake = 0.0
		print(engine_force_input, ";", speed)
		if abs(speed) > 3 and ((engine_force_input < 0.0 and speed > 0.0) or (engine_force_input > 0.0 and speed < 0.0)):
			engine_force = 0.0
			brake = abs(engine_force_input) * brake_value
		else:
			# Increase engine force at low speeds to make the initial acceleration faster.
			if abs(speed) < 5 and speed != 0:
				engine_force = clamp(engine_force_value * 5 / abs(speed), engine_force_value, power_max)
			else:
				engine_force = engine_force_value
			engine_force *= engine_force_input
	else:
		engine_force = 0.0
		brake = brake_input * brake_value
