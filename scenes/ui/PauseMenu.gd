extends CanvasLayer

export(String) var retryScene = ""
onready var messageBroker = MessageBroker

func _ready():
	$Backing/Fill/HBoxContainer/RetryButton.grab_focus()

func _on_RetryButton_pressed():
	messageBroker.emit_signal("load_level", retryScene)
	queue_free()
 
func _on_QuitButton_pressed():
	messageBroker.emit_signal("load_main_menu")
