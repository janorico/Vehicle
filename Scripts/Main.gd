extends Spatial

signal setup_ready

func _ready():
	if not Global.setted_up_bool and not Net.is_offline and not Net.is_host:
		yield(Global, "setted_up")
	if Net.is_offline:
		$Control/VBoxContainer/SendMessageButton.disabled = true
	var world = load(Global.worlds[Global.world].scene_path).instance()
	add_child(world)
	if Net.is_offline:
		$Vehicles.add_child(load_player(Net.my_info))
	else:
		create_my_player()
		for p in Net.player_info:
			create_player(p)
		# warning-ignore:return_value_discarded
		Net.connect("player_connected", self, "create_player")
		# warning-ignore:return_value_discarded
		Net.connect("player_disconnected", self, "remove_player")
	if Global.day_night_cycle == true:
		$DayAnimator.play("Day")
	emit_signal("setup_ready")
	if not $Vehicles.get_vehicle() is Vehicle:
		$Control/VBoxContainer/HandbrakeButton.disabled = true

func remove_player(id):
	print_stack()
	print("	Removing player ", id, "...")
	$Vehicles.remove_child($Vehicles.get_node(str(id)))

func create_player(id):
	print_stack()
	print("	Creating player ", id, "...")
	if Global.day_night_cycle:
		rpc("_update_day_night")
	var info = Net.player_info[id]
	var p = load_player(info)
	$Vehicles.add_child(p)
	p.name = str(id)
	p.get_child(0).initialize(id)
	p.get_child(0).set_player_name(info["name"])
	$Vehicles.get_vehicle().update_camera()

func create_my_player():
	print_stack()
	print("	Creating player...")
	var p = load_player(Net.my_info)
	$Vehicles.add_child(p)
	p.name = str(Net.net_id)
	p.get_child(0).initialize(Net.net_id)

func load_player(info: Dictionary):
	var vehicle = load(Global.vehicles[info["vehicle"]]["path"]).instance()
	for child in vehicle.get_children():
		child.translation.y += Global.worlds[Global.world].vehicle_start.y_translation
		child.rotation_degrees.y += Global.worlds[Global.world].vehicle_start.y_rotation
	return vehicle

remote func _update_day_night():
	if Net.is_host:
		rpc("_seek_day_night", $DayAnimator.current_animation_position)

remote func _seek_day_night(new_pos):
	$DayAnimator.seek(new_pos, true)
