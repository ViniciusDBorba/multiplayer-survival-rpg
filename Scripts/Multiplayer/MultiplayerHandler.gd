extends Node

enum game_status {
	RUNNING,
	PAUSED,
	ENDING,
}
var actual_game_status = game_status.RUNNING

var init_commands = {}


var playersInfo = {}
var playersDone = []
var playersReady = []
var myInfo = {"name":"", "faction": 0, "status": 1}

onready var network = NetworkedMultiplayerENet.new()
onready var timer = Timer.new()

func _ready():
	network.allow_object_decoding = true
	
	connect_to_network_signal("network_peer_connected", "_player_connected")
	connect_to_network_signal("network_peer_disconnected", "_player_disconnected")
	connect_to_network_signal("connected_to_server", "_connected_ok")
	connect_to_network_signal("connection_failed", "_connected_fail")
	connect_to_network_signal("server_disconnected", "_server_disconnected")
	
	configure_server()

func connect_to_network_signal(signal_name, function_name):
	var error = get_tree().connect(signal_name, self, function_name)
	if error:
		printerr(error)

func running_on_server():
	return "--server" in OS.get_cmdline_args()

func configure_server():
	if OS.get_cmdline_args().size() > 0 and running_on_server():
		find_init_commands()
		host_game()

func find_init_commands():
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			init_commands[key_value[0].lstrip("--")] = key_value[1]

func save_player_name(playerName): 
	myInfo.name = playerName
	
func save_player_faction(playerFaction): 
	myInfo.faction = playerFaction

func host_game():
	myInfo.name = "SERVER"
	if !init_commands.has("port"):
		init_commands["port"] = "44444"
	network.create_server(int(init_commands.port), 3)
	get_tree().network_peer = network
	get_tree().call_group("Menu", "toggle_lobby_visibility")
	print("Server is ready on port: " + init_commands.port)

func connect_game(ip):
	network.create_client(ip, 44444)
	get_tree().network_peer = network
	get_tree().call_group("Menu", "toggle_lobby_visibility")
	get_tree().call_group("MultiplayerMenu", "add_player_to_list", myInfo, get_tree().get_network_unique_id())

func _player_connected(id):
	rpc_id(id, "register_player", myInfo)
	print("Player " + str(id) + " connected")

func _connected_ok():
	pass

func _connected_fail(error):
	printerr(error)

remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	playersInfo[id] = info
	if(id != 1):
		get_tree().call_group("MultiplayerMenu", "add_player_to_list", info, id)

func press_ready_button():
	rpc_id(1, "toggle_ready")
	
remote func toggle_ready():
	var who = get_tree().get_rpc_sender_id()

	assert(get_tree().is_network_server())
	assert(who in playersInfo)
	
	if not who in playersReady:
		playersReady.append(who)
		rpc("player_ready", who, true)
	else:
		playersReady.remove(playersReady.find(who, 0))
		rpc("player_ready", who, false)
	
	if playersReady.size() == playersInfo.size():
		start_game()

remote func player_ready(who, is_ready):
	get_tree().call_group("MultiplayerMenu", "set_player_is_ready", str(who), is_ready)

func start_game():
	if playersInfo.size() > 0 and get_tree().get_network_unique_id() == 1:
		timer.connect("timeout", self, "configure_game")
		timer.set_wait_time(1)
		add_child(timer)
		timer.start()

func configure_game():
	timer.stop()
	pre_configure_game()
	for p in playersInfo:
		rpc_id(p, "pre_configure_game")

remote func pre_configure_game():
	get_tree().set_pause(true)
	var selfPeerID = get_tree().get_network_unique_id()
	# Load world
	var world = load("res://Levels/TestScene.tscn").instance()
	var menu = get_node("/root/Node")
	if menu != null:
		get_node("/root/Node").queue_free()
	get_node("/root").add_child(world)

	# Load my player
	instantiate_player(selfPeerID)
		
	# Load other players
	for p in playersInfo:
		instantiate_player(p)
	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
	if selfPeerID != 1:
		rpc_id(1, "done_preconfiguring")

func instantiate_player(id):
	var test_scene = get_node("/root/TestScene")
	if id != 1:
		var player = preload("res://player/Player.tscn").instance()
		player.set_name(str(id))
		player.set_network_master(id, true)
		test_scene.add_child(player)
		player.initialize()
		player.player_spawned(myInfo.faction)

remote func done_preconfiguring():
	var who = get_tree().get_rpc_sender_id()
	
	assert(get_tree().is_network_server())
	assert(who in playersInfo)
	assert(not who in playersDone)
	
	playersDone.append(who)

	if playersDone.size() == playersInfo.size():
		rpc("post_configure_game")

remotesync func post_configure_game():
	playersDone.clear()
	get_tree().set_pause(false)

func set_player_status(player_status):
	playersInfo[get_tree().get_rpc_sender_id()].status = player_status

func _server_disconnected():
	pass
	
func _player_disconnected(id):
	playersInfo.erase(id)
	get_tree().call_group("MultiplayerMenu", "remove_player_from_list", id)
