extends Node

signal setted_up

var worlds = {
	sketchup_world = {
		name = "SKETCHUP_WORLD_KEY",
		preview_path = "res://Assets/Worlds/Images/SketchUpWorld.png",
		scene_path = "res://Scenes/Worlds/SketchUpWorld/SketchUpWorld.tscn",
		map_path = "res://Assets/Navigation/SketchUpWorld.png",
		map_divider = 48.0,
		vehicle_start = {
			y_translation = 0.0,
			y_rotation = 90.0,
		},
	},
	gridmap_world = {
		name = "GRIDMAP_WORLD_KEY",
		preview_path = "res://Assets/Worlds/Images/GridMapWorld.png",
		scene_path =  "res://Scenes/Worlds/GridMapWorld/GridMapWorld.tscn",
		map_path =  "res://Assets/Navigation/GridMapWorld.png",
		map_divider = 4.0,
		vehicle_start = {
			y_translation = 0.0,
			y_rotation = 0.0,
		},
	},
	real_world = {
		name = "REAL_WORLD_KEY",
		preview_path = "res://Assets/Worlds/Images/RealWorld.png",
		scene_path = "res://Scenes/Worlds/RealWorld/RealWorld.tscn",
		map_path =  "res://Assets/Navigation/RealWorld.png",
		map_divider = 4.0,
		vehicle_start = {
			y_translation = 27.25,
			y_rotation = 0.0,
		},
	},
}

var vehicles = {
	car = {
		path = "res://Scenes/Vehicles/Car.tscn",
	},
	quad_bike = {
		path = "res://Scenes/Vehicles/QuadBike.tscn",
	},
	truck = {
		path = "res://Scenes/Vehicles/Truck.tscn",
	},
	tractor = {
		path = "res://Scenes/Vehicles/Tractor.tscn",
	},
	minibus = {
		path = "res://Scenes/Vehicles/Minibus.tscn",
	},
	large_dump_truck = {
		path = "res://Scenes/Vehicles/LargeDumpTruck.tscn",
	},
	car_legacy = {
		path = "res://Scenes/Vehicles/CarLegacy.tscn",
	},
	helicopter = {
		path = "res://Scenes/Vehicles/Helicopter.tscn",
	},
	dump_truck = {
		path = "res://Scenes/Vehicles/DumpTruck.tscn",
	},
	mini_snowplow = {
		path = "res://Scenes/Vehicles/MiniSnowplow.tscn",
	},
}

# Last states
var last_states_path := "user://last_states.json"
# Keys
const WINDOW_STATE_KEY = "window_state"
const LAST_VEHICLE_KEY = "last_vehicle"
const LAST_WORLD_KEY = "last_world"
const LAST_NAME_KEY = "last_name"
const LAST_TYPED_NAME_KEY = "last_typed_name"
const LAST_SERVER_IP_KEY = "last_server_ip"
const LAST_TYPED_SERVER_IP_KEY = "last_typed_server_ip"
const LAST_PORT_KEY = "last_port"
const LAST_MAX_PLAYERS_KEY = "last_max_players"
const LAST_DAY_NIGTH_CYCLE = "last_day_night_cycle"
const LAST_USED_VIEW_KEY = "last_used_view"
# Values
var window_state := "fullscreen"
var last_vehicle := 0
var last_world := 0
var last_name := ""
var last_server_ip := ""
var last_port := 31400
var last_max_players := 20
var last_day_night_cycle := false
var last_used_view = VehicleBase.CameraType.WINDSCREEN
# Setup
var setted_up_bool := false
var day_night_cycle := true
var world := "sketchup_world"

remote func setup(dnc: bool, w):
	day_night_cycle = dnc
	world = w
	setted_up_bool = true
	emit_signal("setted_up")

func _ready():
	load_last_states()
	# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "save_last_states")

func _physics_process(_delta):
	if Input.is_action_just_released("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		save_last_states()
	if Input.is_action_just_released("toggle_mouse_mode"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_released("exit"):
		get_tree().quit(0)

func inverse(original):
	if original > 0:
		return -original
	if original == 0:
		return 0
	if original < 0:
		return abs(original)

func load_last_states():
	var file = File.new()
	if file.file_exists(last_states_path) == true:
		file.open(last_states_path, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if data.has(WINDOW_STATE_KEY):			 window_state = data[WINDOW_STATE_KEY]
		if data.has(LAST_VEHICLE_KEY):			 last_vehicle = data[LAST_VEHICLE_KEY]
		if data.has(LAST_WORLD_KEY):			 last_world = data[LAST_WORLD_KEY]
		if data.has(LAST_NAME_KEY):				 last_name = data[LAST_NAME_KEY]
		elif data.has(LAST_TYPED_NAME_KEY):		 last_name = data[LAST_TYPED_NAME_KEY]
		if data.has(LAST_SERVER_IP_KEY):		 last_server_ip = data[LAST_SERVER_IP_KEY]
		elif data.has(LAST_TYPED_SERVER_IP_KEY): last_server_ip = data[LAST_TYPED_SERVER_IP_KEY]
		if data.has(LAST_PORT_KEY):				 last_port = data[LAST_PORT_KEY]
		if data.has(LAST_MAX_PLAYERS_KEY):		 last_max_players = data[LAST_MAX_PLAYERS_KEY]
		if data.has(LAST_DAY_NIGTH_CYCLE):		 last_day_night_cycle = data[LAST_DAY_NIGTH_CYCLE]
		if data.has(LAST_USED_VIEW_KEY):		 last_used_view = data[LAST_USED_VIEW_KEY]
	set_window_state()

func set_window_state():
	if window_state == "maximized":
		OS.window_maximized = true
	elif window_state == "fullscreen":
		OS.window_fullscreen = true
	else:
		var state = parse_json(window_state)
		OS.window_size = Vector2(state["size_x"], state["size_y"])
		OS.window_position = Vector2(state["position_x"], state["position_y"])

func get_window_state():
	if OS.window_maximized:
		window_state = "maximized"
	elif OS.window_fullscreen:
		window_state = "fullscreen"
	else:
		var size = OS.window_size
		var position = OS.window_position
		window_state = to_json({
			"size_x" : size.x,
			"size_y" : size.y,
			"position_x" : position.x,
			"position_y" : position.y
		})

func save_last_states():
	get_window_state()
	var file = File.new()
	file.open(last_states_path, File.WRITE)
	var json_data = {
		WINDOW_STATE_KEY: window_state,
		LAST_VEHICLE_KEY: last_vehicle,
		LAST_WORLD_KEY: last_world,
		LAST_NAME_KEY: last_name,
		LAST_SERVER_IP_KEY: last_server_ip,
		LAST_PORT_KEY: last_port,
		LAST_MAX_PLAYERS_KEY: last_max_players,
		LAST_DAY_NIGTH_CYCLE: last_day_night_cycle,
		LAST_USED_VIEW_KEY: last_used_view
	}
	file.store_line(to_json(json_data))
	file.close()

	return "res://Assets/Navigation/Map.png"
