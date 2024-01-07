extends Node2D


onready var messageBroker = MessageBroker
onready var bridge = $Bridge/Bridge
export(float) var bridgeSpeed = 20
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")

func on_player_picked_up_coin():
	OpenBridge()

func OpenBridge():
	opened = true

func _process(delta):
	if opened:
		if bridge.rotation_degrees > -90:
			bridge.rotation_degrees = bridge.rotation_degrees - delta * bridgeSpeed
		else:
			bridge.rotation_degrees = -90
