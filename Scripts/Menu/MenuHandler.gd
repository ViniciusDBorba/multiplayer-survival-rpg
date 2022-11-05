extends Node

onready var initialMenu = $InitialMenu
onready var playerMenu = $PlayerMenu
onready var multiplayer_lobby = $MultiplayerLobby
onready var playerNameInput = $PlayerMenu/NameInput
onready var serverIpInput = $PlayerMenu/IpInput
onready var facButton = $PlayerMenu/SelectFacButton
onready var multiplayerHandler = get_node("/root/MultiplayerHandler")
onready var texts_handler = get_node("/root/TextHandler")

func _ready():
	texts_handler.connect("language_file_updated", self, "update_ui_texts")
	update_ui_texts()
	
func update_ui_texts():
	facButton.clear()
	var metadata = "militaries"
	facButton.add_item(texts_handler.get_text(metadata))
	facButton.set_item_metadata(facButton.get_item_count() - 1, metadata)
	metadata = "outlaws"
	facButton.add_item(texts_handler.get_text(metadata))
	facButton.set_item_metadata(facButton.get_item_count() - 1, metadata)
	metadata = "renegades"
	facButton.add_item(texts_handler.get_text(metadata))
	facButton.set_item_metadata(facButton.get_item_count() - 1, metadata)

	facButton.text = texts_handler.get_text("select_fac")
	playerNameInput.placeholder_text = texts_handler.get_text("name")
	serverIpInput.placeholder_text = texts_handler.get_text("server_ip")
	playerMenu.get_node("PlayButton").text = texts_handler.get_text("play")
	playerMenu.get_node("Game Title").text = texts_handler.get_text("game_title")
	initialMenu.get_node("HostButton").text = texts_handler.get_text("host_server")
	initialMenu.get_node("ConnectButton").text = texts_handler.get_text("connect_server")

func toggle_lobby_visibility():
	multiplayer_lobby.visible = !multiplayer_lobby.visible

func _on_PlayButton_pressed():
	multiplayerHandler.save_player_name(playerNameInput.text)
	multiplayerHandler.save_player_faction(facButton.get_item_metadata(facButton.get_selected_id()))
	playerMenu.visible = false
	var serverIp = serverIpInput.text
	if serverIp == null or serverIp == "":
		serverIp = "localhost"
	multiplayerHandler.connect_game(serverIp)

func _on_ReadyButton_pressed():
	multiplayerHandler.press_ready_button()

func _on_HostButton_pressed():
	multiplayerHandler.host_game()

func _on_ConnectButton_pressed():
	initialMenu.hide()
	playerMenu.show()
