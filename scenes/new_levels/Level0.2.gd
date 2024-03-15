extends Node2D

onready var messageBroker = MessageBroker
onready var movingPlatform = $MovingPlatforms/MovingPlatform4


func _ready():
	movingPlatform.set_physics_process(false)
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")


func on_player_picked_up_coin():
	movingPlatform.set_physics_process(true)
