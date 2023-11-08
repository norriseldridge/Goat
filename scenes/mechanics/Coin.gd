extends Area2D

onready var messageBroker = MessageBroker

func _on_Coin_body_entered(body):
	messageBroker.emit_signal("player_picked_up_coin")
	queue_free()
