extends Area2D

onready var messageBroker = MessageBroker

func _on_Food_body_entered(_body):
	messageBroker.emit_signal("player_picked_up_food")
	queue_free()
