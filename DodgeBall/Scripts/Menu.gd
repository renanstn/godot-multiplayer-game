extends Control


onready var name_input = $Panel/VBoxContainer/NameInput

func _on_JoinButton_button_down():
	var player_name = name_input.text
	if player_name == "":
		return
	Global.create_player(player_name)
	get_tree().change_scene("res://Scenes/Game.tscn")
