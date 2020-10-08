extends Node2D


var players = []
var player_instance = preload("res://Scenes/Player.tscn")
var other_player = preload("res://Scenes/OtherPlayer.tscn")
onready var spawn_point = $campo/EnemySpawnPoint


class Player:
	var name
	var instance
	func _init(player_name, player_instance):
		self.name = player_name
		self.instance = player_instance

func _ready():
	create_player()

func create_player():
	var instance = player_instance.instance()
	instance.position = Vector2(255, 256)
	var player = Player.new(Global.PLAYER_NAME, instance)
	players.append(player)
	add_child(instance)

func create_enemy_player(enemy_name):
	var enemy_instance = other_player.instance()
	enemy_instance.position = spawn_point.global_position
	var enemy = Player.new(enemy_name, enemy_instance)
	players.append(enemy)
	add_child(enemy_instance)

func update_player_position(player_name, position):
	for player in players:
		if player.name == player_name:
			player.instance.position = Vector2(position[0], position[1])

func update_all_players(data):
	"""
	Função que recebe o JSON do backend, e atualiza todas as
	posições dos jogadores a partir dele.
	"""
	for player in data:
		update_player_position(player['name'], player['position'])
