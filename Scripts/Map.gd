extends Control


var ready_to_draw: bool = false
var map_texture: Texture
var map_divider: float
var map_size: Vector2 = Vector2.ZERO
var center_x: float
var center_y: float


func _initialize():
	map_texture = load(Global.worlds[Global.world].map_path)
	map_divider = Global.worlds[Global.world].map_divider
	map_size = map_texture.get_size()
	center_x = (map_size.x / 2)
	center_y = ((map_size.y / 2))
	ready_to_draw = true


func _process(_delta):
	update()


func get_vehicles():
	return get_vehicles_node().get_children()


func get_vehicles_node():
	return get_node("../../../Vehicles")


func _draw():
	if not ready_to_draw:
		return
	draw_rect(Rect2(0, 0, map_size.x, map_size.y), Color.black)
	draw_texture(map_texture, Vector2(0, 0))
	if Net.is_offline:
		draw_circle(get_circle_position(get_vehicles_node().get_vehicle().translation), 3, Color.red)
	else:
		for vehicle in get_vehicles():
			vehicle = vehicle.get_child(0)
			var position = vehicle.get_translation()
			if vehicle.is_master:
				draw_circle(get_circle_position(position), 3, Color.red)
			else:
				draw_circle(get_circle_position(position), 3, Color.blue)


func get_circle_position(vehicle_position: Vector3):
	var x = Global.inverse(vehicle_position.x) / map_divider
	var y = Global.inverse(vehicle_position.z) / map_divider
	return Vector2((center_x + x), (center_y + y))
