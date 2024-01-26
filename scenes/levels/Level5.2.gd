extends Node2D

onready var messageBroker = MessageBroker

onready var key = $Key
onready var collision = $Key/CollisionShape2D

func _ready():
	SetKeyActive(false)
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")

func on_player_picked_up_coin():
	SetKeyActive(true)

func SetKeyActive(state):
	key.visible = state
	collision.set_deferred("disabled", !state)
