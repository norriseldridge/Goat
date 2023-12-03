extends Area2D

onready var messageBroker = MessageBroker

func _on_LevelLoadZone_body_entered(body):
	messageBroker.emit_signal("player_entered_portal")
