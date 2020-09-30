extends Node


var PLAYER_NAME
var PLAYERS = []
var active_players = []
var player_instance
var other_player = preload("res://Scenes/OtherPlayer.tscn")

class Player:
	var name
	var instance
	func _init(player_name, player_instance):
		self.name = player_name
		self.instance = player_instance

func create_player(player_name):
	PLAYER_NAME = player_name
	print(player_name)
	var player = Player.new(player_name, player_instance)
	print(player)
	PLAYERS.append(player)
	active_players.append(player_name)

func create_enemy_player(player_name):
	var player_instance = other_player.instance()
	player_instance.position = Vector2(0, 0)
	var player_obj = Player.new(player_name, player_instance)
	PLAYERS.append(player_obj)
	active_players.append(player_name)
	get_parent().add_child(player_instance)

func update_player_position(player_name, position):
	print('Updating position of')
	print(player_name)
	print(position)
	print(PLAYERS)
	for player in PLAYERS:
		if player.name == player_name:
			print(player.global_position)
#			player.instance.global_position = Vector2(position[0], position[1])

func update_all_players(data):
	"""
	Função que recebe o JSON do backend, e atualiza todas as
	posições dos jogadores a partir dele.
	"""
	print('updating all players positions')
	for player in data.keys():
		if not active_players.has(player):
			print('new player detected')
			create_enemy_player(player)
		else:
			print('just update')
			update_player_position(player, data[player]['position'])
