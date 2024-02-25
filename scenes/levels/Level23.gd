extends Node2D


onready var messageBroker = MessageBroker
onready var stove = $Stove3


# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")


func on_player_picked_up_coin():
	stove.next_state()