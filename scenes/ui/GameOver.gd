extends CanvasLayer

export(String) var retryScene = ""
onready var messageBroker = MessageBroker

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		messageBroker.emit_signal("load_level", retryScene)
		queue_free()
	
	if Input.is_action_just_pressed("ui_cancel"):
		# TODO load the main menu
		get_tree().quit()
