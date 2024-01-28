extends Node2D


onready var messageBroker = MessageBroker
onready var bridge = $Bridge/Bridge
export(float) var bridgeSpeed = 20.0
onready var gem = $Gem3
onready var gemCollision = $Gem3/CollisionShape2D
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	gem.visible = false
	gemCollision.set_deferred("disabled", true)

func on_player_picked_up_coin():
	if !opened:
		OpenBridge()
	else:
		ShowGem()

func OpenBridge():
	opened = true

func ShowGem():
	gem.visible = true
	gemCollision.set_deferred("disabled", false)

func _process(delta):
	if opened:
		if bridge.rotation_degrees > -90:
			bridge.rotation_degrees = bridge.rotation_degrees - delta * bridgeSpeed
		else:
			bridge.rotation_degrees = -90
