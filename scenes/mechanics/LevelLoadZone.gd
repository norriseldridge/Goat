extends Area2D

export var nextLevel = ""
onready var messageBroker = MessageBroker

func _on_LevelLoadZone_body_entered(body):
	messageBroker.emit_signal("player_entered_portal", nextLevel)
