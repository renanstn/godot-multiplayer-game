extends Area2D


func _ready():
	WebSocket.connect("connected", self, "_on_connect")
	WebSocket.ws_connect()
	Global.player_instance = self
	
func _on_connect():
	WebSocket.set_position(self.global_position.x, self.global_position.y)

func _process(delta):
	if Input.is_action_just_pressed("up"):
		WebSocket.move_character("up")
	if Input.is_action_just_pressed("down"):
		WebSocket.move_character("down")
	if Input.is_action_just_pressed("left"):
		WebSocket.move_character("left")
	if Input.is_action_just_pressed("right"):
		WebSocket.move_character("right")
