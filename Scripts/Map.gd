extends TextureRect


const NAVIGATION_ARROW = preload("res://Assets/2D/NavigationArrow.svg")
var map_divider: float
var players := {}


func _ready() -> void:
	texture = load(Global.worlds[Global.world].map_path)
	map_divider = Global.worlds[Global.world].map_divider
	if Net.is_offline:
		create_player("Spatial")
	else:
		create_player(Net.net_id)
		for id in Net.player_info:
			create_player(id)
		Net.connect("player_connected", self, "create_player")
		Net.connect("player_disconnected", self, "remove_player")


func _process(_delta: float) -> void:
	for id in players:
		var s = players[id]
		var p = get_node("../../../Vehicles/%s" % id)
		if p:
			var v: Spatial = p.get_child(0)
			s.position = world2map(v.position)
			s.rotation = v.transform.basis.inverse().get_euler().y


func create_player(id) -> void:
	var s = Sprite.new()
	s.name = str(id)
	s.texture = NAVIGATION_ARROW
	if not Net.is_offline:
		s.modulate = Color.red if id == Net.net_id else Color.blue
	add_child(s)
	players[id] = s


func remove_player(id) -> void:
	players[id].queue_free()
	players.erase(id)


func world2map(vehicle_position: Vector3) -> Vector2:
	return Vector2(
		(-vehicle_position.x) / map_divider,
		(-vehicle_position.z) / map_divider
	) + (rect_size / 2)
