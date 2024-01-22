extends Area2D


onready var messageBroker = MessageBroker


func _on_Gem_body_entered(body):
	messageBroker.emit_signal("player_picked_up_gem")
	queue_free()
