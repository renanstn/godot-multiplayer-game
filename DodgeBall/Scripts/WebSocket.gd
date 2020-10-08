extends Node


export var websocket_url = "ws://localhost:5000/"
var _client = WebSocketClient.new()

signal connected

func ws_connect():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(protocol):
	print("Connected with protocol: ", protocol)
	emit_signal("connected")
	var data = {
		"action": "join_player",
		"player_name": Global.PLAYER_NAME
	}
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _on_data():
	var data = _client.get_peer(1).get_packet().get_string_from_utf8()
	var parsed_data = JSON.parse(data).result
	var game = get_node("/root/Game")
	if parsed_data['action'] == 'update_positions':
		game.update_all_players(parsed_data['data'])
	elif parsed_data['action'] == 'new_player':
		game.create_enemy_player(parsed_data['player_name'])

func move_character(direction):
	var data = {
		"action": "update_position",
		"player_name": Global.PLAYER_NAME,
		"direction": direction
	}
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _process(delta):
	if _client.get_connection_status() == _client.CONNECTION_CONNECTED:
		_client.poll()
