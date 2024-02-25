extends Node2D

onready var messageBroker = MessageBroker
onready var dialogue = $Dialogue
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_food", self, "on_player_picked_up_food")
	messageBroker.connect("dialogue_complete", self, "on_dialogue_complete")

func on_player_picked_up_food():
	dialogue.Show()
	player.animatedSprite.flip_h = true
	player.allowedToMove = false

func on_dialogue_complete():
	player.allowedToMove = true