extends Node2D

onready var messageBroker = MessageBroker
onready var spikes = $Spikes3
onready var bat = $Birdy
onready var killCollision = $Birdy/KinematicBody2D/KillZone/CollisionShape2D
onready var batCollision = $Birdy/KinematicBody2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	bat.set_physics_process(false)
	bat.visible = false
	batCollision.set_deferred("disabled", true)
	killCollision.set_deferred("disabled", true)


func on_player_picked_up_coin():
	spikes.queue_free()
	bat.set_physics_process(true)
	bat.visible = true
	batCollision.set_deferred("disabled", false)
	killCollision.set_deferred("disabled", false)