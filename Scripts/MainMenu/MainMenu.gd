extends Node

enum {
	PLAY_BUTTON_SINGLEPLAYER = 0,
	PLAY_BUTTON_HOST = 1,
	PLAY_BUTTON_JOIN = 2,
}

onready var vehicles = $Vehicles
onready var worlds = $Container/VBoxContainer/WorldScroller/Worlds
onready var name_line_edit = $Container/VBoxContainer/PanelContainer/Options/NameLineEdit
onready var server_ip_line_edit = $Container/VBoxContainer/PanelContainer/Options/ServerIPLineEdit
onready var port_spin_box = $OptionsDialog/GridContainer/PortSpinBox
onready var max_players_spin_box = $OptionsDialog/GridContainer/MaxPlayersSpinBox
onready var day_night_cycle_toggle = $OptionsDialog/GridContainer/DayNightCycleCheckButton
onready var tonemap_option_button = $OptionsDialog/GridContainer/TonemapOptionButton
onready var glow_toggle = $OptionsDialog/GridContainer/GlowCheckButton


func _ready() -> void:
	# Last values
	vehicles.selected_vehicle = Global.last_vehicle
	vehicles.update_selection()
	worlds.selected_world = Global.last_world
	worlds.init_buttons()
	name_line_edit.text = Global.last_name
	server_ip_line_edit.text = Global.last_server_ip
	port_spin_box.value = Global.last_port
	max_players_spin_box.value = Global.last_max_players
	day_night_cycle_toggle.pressed = Global.last_day_night_cycle
	tonemap_option_button.selected = Global.graphics_tonemap
	glow_toggle.pressed = Global.graphics_glow
	# Connect buttons
	$Container/System/InfoButton.get_popup().connect("id_pressed", self, "_on_info_button_pressed")
	$Container/Actions/PlayButton.get_popup().connect("id_pressed", self, "_on_play_button_item_pressed")
	# Update camera
	$Environment/Camera.make_current()


func _exit_tree() -> void:
	Global.last_vehicle = vehicles.selected_vehicle
	Global.last_world = worlds.selected_world
	Global.last_name = name_line_edit.text
	Global.last_server_ip = server_ip_line_edit.text
	Global.last_port = port_spin_box.value
	Global.last_max_players = max_players_spin_box.value
	Global.last_day_night_cycle = day_night_cycle_toggle.pressed
	Global.graphics_tonemap = tonemap_option_button.selected
	Global.graphics_glow = glow_toggle.pressed
	Global.save_last_states()


func swap_to_wp() -> Node:
	var wp = load("res://Scenes/WaitPage.tscn").instance()
	get_tree().get_root().add_child(wp)
	get_tree().current_scene = wp
	queue_free()
	return wp


func current_info() -> Dictionary:
	return {
		name = name_line_edit.text,
		vehicle = Global.vehicles.keys()[vehicles.selected_vehicle],
	}


func day_night_cycle_enabled() -> bool:
	return day_night_cycle_toggle.pressed


func current_port() -> int:
	return port_spin_box.value


func selected_world_name() -> String:
	return Global.worlds.keys()[worlds.selected_world]


func _on_play_button_item_pressed(id: int) -> void:
	match id:
		PLAY_BUTTON_SINGLEPLAYER:
			var wp = swap_to_wp()
			wp.offline(current_info(), day_night_cycle_enabled(), selected_world_name())
		PLAY_BUTTON_HOST:
			var wp = swap_to_wp()
			wp.host(current_info(), current_port(), max_players_spin_box.value, day_night_cycle_enabled(), selected_world_name())
		PLAY_BUTTON_JOIN:
			var wp = swap_to_wp()
			wp.join(current_info(), current_port(), server_ip_line_edit.text)


func _on_info_button_pressed(id: int) -> void:
	match id:
		0:
			$AboutDialog.popup_centered()
		1:
			$LicenseInformationDialog.popup_centered()


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
