extends Node2D


onready var messageBroker = MessageBroker
onready var coin2 = $Coin2
onready var coin3 = $Coin3
onready var portal = $Portal
onready var levelLoadZone = $Portal/LevelLoadZone

var coinIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SetCoinActive(coin2, false)
	SetCoinActive(coin3, false)
	SetPortalActive(false)
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")


func on_player_picked_up_coin():
	coinIndex += 1
	if coinIndex == 1:
		SetCoinActive(coin2, true)
	if coinIndex == 2:
		SetCoinActive(coin3, true)
	if coinIndex == 3:
		SetPortalActive(true)

func SetCoinActive(coin, state):
	coin.visible = state
	coin.monitoring = state

func SetPortalActive(state):
	portal.visible = state
	levelLoadZone.monitoring = state