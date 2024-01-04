extends Node2D

onready var messageBroker = MessageBroker
onready var gate = $Gate
onready var end = $EndPoint
onready var sfx = $Gate/AudioStreamPlayer2D

var gateOpen = false
var gateOpened = false
var speed = 90

func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")

func on_player_picked_up_coin():
	sfx.play()
	gateOpen = true

func _process(delta):
	if gateOpen:
		var movement = gate.position.direction_to(end.position)
		if gate.position.distance_to(end.position) >= 1:
			gate.position = gate.position + (movement * speed * delta)
		else:
			gate.position = end.position
			if !gateOpened:
				gateOpened = true
				sfx.pitch_scale = 0.8
				sfx.play()
