extends CenterContainer

const MAIN_MENU_SCENE = preload("res://Scenes/MainMenu.tscn")
const MAIN_SCENE = preload("res://Scenes/Main.tscn")

func _ready():
	# warning-ignore:return_value_discarded
	Net.connect("connected_to_server", self, "_server_connected")
	# warning-ignore:return_value_discarded
	Net.connect("connection_failed", self, "_connection_failed")

func server_disconnected():
	$VBoxContainer/Label.text = "SERVER_DISCONNECTED_KEY"
	$VBoxContainer/Button.show()

func _server_connected():
	$VBoxContainer/Label.text = "CONNECTION_SUCCESS_KEY"
	if not Net.is_host:
		start_network_game()

func _connection_failed():
	$VBoxContainer/Label.text = "CONNECTION_FAILED_KEY"
	$VBoxContainer/Button.show()

func host(info, port, max_players, day_night_cycle, world):
	Global.setup(day_night_cycle, world)
	Net.initialize_server(info, port, max_players)
	start_network_game()

func join(info, port, ip):
	$VBoxContainer/Label.text = "CONNECTING_TO_SERVER_KEY"
	Net.initialize_client(info, port, ip)

func offline(info, day_night_cycle, world):
	$VBoxContainer/Label.text = "STARTING_OFFLINE_GAME_KEY"
	Net.is_offline = true
	Net.my_info = info
	Global.setup(day_night_cycle, world)
	change_scene(MAIN_SCENE)

func start_network_game():
	Net.net_id = get_tree().get_network_unique_id()
	change_scene(MAIN_SCENE)

func change_scene(scene: PackedScene):
	$VBoxContainer/Label.text = "LOADING_KEY"
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	get_parent().add_child(scene.instance())
	queue_free()

func _play_again():
	change_scene(MAIN_MENU_SCENE)
