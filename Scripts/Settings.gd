extends ConfirmationDialog

signal changed

export(String) var settings_file_path = "user://vehicle_settings.json"
onready var engine_force_value_spin_box = $GridContainer/EngineForceValueSpinBox
onready var brake_value_spin_box = $GridContainer/BrakeValueSpinBox
onready var steer_limit_spin_box = $GridContainer/SteerLimitSpinBox
onready var steer_speed_spin_box = $GridContainer/SteerSpeedSpinBox
onready var control_device_option_button = $GridContainer/ControlDeviceOptionButton
onready var crash_monitor_check_button = $GridContainer/CrashMonitorCheckButton
onready var crashs_reported_spin_box = $GridContainer/CrashsReportedSpinBox

func _setup():
	load_settings()
	control_device_option_button.add_item("KEYBOARD_KEY", 0)
	control_device_option_button.add_item("MOUSE_KEY", 1)
	var vehicle = get_vehicle()
	#if vehicle != null and vehicle is Vehicle:
	#	for port_name in vehicle.get_ports():
	#		control_device_option_button.add_item(str(port_name))
	if not Net.is_offline:
		engine_force_value_spin_box.set_editable(false)

func save_settings(engine_force_value: int, brake_value: float, steer_limit: float, steer_speed: float, crash_monitor: bool, crashs_reported: int):
	var file = File.new()
	file.open(settings_file_path, File.WRITE)
	var json_data = {
		"engine_force_value" : engine_force_value,
		"brake_value" : brake_value,
		"steer_limit" : steer_limit,
		"steer_speed" : steer_speed,
		"crash_monitor" : crash_monitor,
		"crashs_reported" : crashs_reported
	}
	file.store_line(to_json(json_data))
	file.close()

func load_settings():
	var file = File.new()
	if !file.file_exists(settings_file_path):
		save_settings(40, 2, 0.4, 1.5, false, 40)
	file.open(settings_file_path, File.READ)
	var data = parse_json(file.get_as_text())
	change_settings(
		data["engine_force_value"],
		data["brake_value"],
		data["steer_limit"],
		data["steer_speed"],
		data["crash_monitor"],
		data["crashs_reported"]
	)
	file.close()

func _dialog_confirmed():
	var control_device = control_device_option_button.get_selected()
	if control_device == 0:
		get_vehicle().control_with_keyboard()
	elif control_device == 1:
		get_vehicle().control_with_mouse()
	else:
		get_vehicle().control_with_serial_port(control_device_option_button.get_item_text(control_device))
	var engine_force_value = engine_force_value_spin_box.value
	var brake_value = (brake_value_spin_box.value / 10)
	var steer_limit = (steer_limit_spin_box.value / 10)
	var steer_speed = (steer_speed_spin_box.value / 10)
	var crash_monitor = crash_monitor_check_button.pressed
	var crashs_reported = crashs_reported_spin_box.value
	change_settings(engine_force_value, brake_value, steer_limit, steer_speed, crash_monitor, crashs_reported)
	save_settings(engine_force_value, brake_value, steer_limit, steer_speed, crash_monitor, crashs_reported)

func get_vehicle():
	return get_node("../../Vehicles").get_vehicle()

func change_settings(engine_force_value: float, brake_value: float, steer_limit: float, steer_speed: float, crash_monitor: bool, crashs_reported: int):
	var vehicle = get_vehicle()
	if vehicle != null:
		vehicle.engine_force_value = engine_force_value
		vehicle.brake_value = brake_value
		vehicle.steer_limit = steer_limit
		vehicle.steer_speed = steer_speed
		vehicle.contact_monitor = crash_monitor
		vehicle.contacts_reported = crashs_reported
	engine_force_value_spin_box.value = engine_force_value
	brake_value_spin_box.value = brake_value * 10
	steer_limit_spin_box.value = steer_limit * 10
	steer_speed_spin_box.value = steer_speed * 10
	crash_monitor_check_button.pressed = crash_monitor
	crashs_reported_spin_box.value = crashs_reported
	emit_signal("changed")
