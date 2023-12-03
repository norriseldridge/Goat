extends Node2D

onready var messageBroker = MessageBroker

onready var portal = $Portal
onready var levelLoadZone = $Portal/LevelLoadZone

func _ready():
	SetPortalActive(false)
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")

func on_player_picked_up_coin():
	SetPortalActive(true)

func SetPortalActive(state):
	portal.visible = state
	levelLoadZone.monitoring = state
