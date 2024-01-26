extends Node2D

onready var messageBroker = MessageBroker

onready var platform = $MovingPlatform
onready var collision = $MovingPlatform/Platform/CollisionShape2D

func _ready():
	SetPlatformActive(false)
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")

func on_player_picked_up_coin():
	SetPlatformActive(true)

func SetPlatformActive(state):
	platform.visible = state
	collision.set_deferred("disabled", !state)