extends Area2D

export(int) var id = 1
onready var messageBroker = MessageBroker
onready var sprite = $Sprite
onready var body = $KinematicBody2D

func _ready():
	messageBroker.connect("player_unlocked_door", self, "on_player_unlocked_door")
	set_locked(true)

func _on_Door_body_entered(body):
	messageBroker.emit_signal("player_entered_door_unlock", id)

func on_player_unlocked_door(doorid):
	if doorid == id:
		set_locked(false)

func set_locked(is_locked):
	sprite.frame = 15 if is_locked else 14
	body.set_collision_layer_bit(0, is_locked)
