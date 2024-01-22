extends Node2D

onready var messageBroker = MessageBroker
onready var dialogue = $Dialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_food", self, "on_player_picked_up_food")

func on_player_picked_up_food():
	dialogue.Show()
