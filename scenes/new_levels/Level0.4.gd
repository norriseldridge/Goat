extends Node2D

onready var messageBroker = MessageBroker
onready var player = $Player
onready var camera = $Camera2D
onready var openGateTimer = $OpenGateTimer
onready var enablePlayerTimer = $EnablePlayerTimer
onready var gate = $Gate
var gateSpeed = 20.0
var coin_index = 0
var coins = []
var shouldOpen = false

func _ready():
	coins = [
		$Coins/Coin,
		$Coins/Coin2,
		$Coins/Coin3,
		$Coins/Coin4,
		$Coins/Coin5,
		$Coins/Coin6,
		$Coins/Coin7
	]

	for i in range(0, coins.size()):
		set_coin_state(coins[i], coin_index == i)
		
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	openGateTimer.connect("timeout", self, "open_gate")
	enablePlayerTimer.connect("timeout", self, "enable_player")

func _process(delta):
	if shouldOpen:
		if gate.position.y > 0:
			gate.position.y -= delta * gateSpeed

func set_coin_state(coin, state: bool):
	if is_instance_valid(coin):
		coin.visible = state
		coin.set_deferred("monitoring", state)

func on_player_picked_up_coin():
	coin_index += 1
	if coin_index < coins.size():
		for i in range(0, coins.size()):
			set_coin_state(coins[i], coin_index == i)
	else:
		StartOpenGate()

func StartOpenGate():
	player.allowedToMove = false
	camera.follow_player = false
	camera.position = Vector2(30, 175)
	openGateTimer.start()

func open_gate():
	enablePlayerTimer.start()
	shouldOpen = true

func enable_player():
	player.allowedToMove = true
	camera.follow_player = true
	camera.position = player.position
