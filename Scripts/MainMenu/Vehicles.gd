extends Spatial

export var spots := []
var transforms := []
var selected_vehicle := 0

onready var camera = get_node("../Environment/Camera")


func _ready() -> void:
	var i = 0
	for vn in Global.vehicles:
		var spot = spots[i]
		var vd = Global.vehicles[vn]
		var v: Spatial = load(vd["path"]).instance()
		v.position = spot["position"]
		v.rotation_degrees.y = spot["orientation"]
		v.get_child(0).capturing = true
		add_child(v)
		transforms.append(v.global_transform)
		i += 1


func update_selection() -> void:
	camera.target = transforms[selected_vehicle]


func next() -> void:
	selected_vehicle = (selected_vehicle + 1) % transforms.size()
	update_selection()


func previous() -> void:
	selected_vehicle = (selected_vehicle - 1) % transforms.size()
	update_selection()
