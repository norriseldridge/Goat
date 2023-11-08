extends Area2D

onready var messageBroker = MessageBroker

func _on_Key_body_entered(body):
	messageBroker.emit_signal("player_picked_up_key")
	queue_free()
