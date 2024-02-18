extends Node2D


onready var messageBroker = MessageBroker
onready var fakeWall = $FakeWall
onready var collision = $FakeWall/Wall1/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")


func on_player_picked_up_coin():
	fakeWall.visible = false
	collision.set_deferred("disabled", true)