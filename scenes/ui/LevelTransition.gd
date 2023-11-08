extends CanvasLayer

export var max_timeout = 1
onready var timeout = max_timeout

onready var messageBroker = MessageBroker
var nextLevel = null

func _process(delta):
	timeout -= delta
	if timeout <= 0:
		messageBroker.emit_signal("load_level", nextLevel)
		queue_free()
