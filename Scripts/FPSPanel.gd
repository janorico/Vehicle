extends Node

onready var fps_label = $GridContainer/FPS
onready var pos_label = $GridContainer/Position
onready var rot_label = $GridContainer/Rotation
var vehicle = null
var position = Vector3.ZERO
var rotation = Vector3.ZERO

func _process(_delta):
	fps_label.text = "%d" % Engine.get_frames_per_second()
	if vehicle != null:
		position = vehicle.translation
		rotation = vehicle.rotation_degrees
	else: set_vehicle()
	pos_label.text = "(%8.2f, %8.2f, %8.2f)" % [position.x, position.y, position.z]
	rot_label.text = "(%8.2f, %8.2f, %8.2f)" % [rotation.x, rotation.y, rotation.z]

func set_vehicle():
	vehicle = get_node("../../Vehicles").get_vehicle()
