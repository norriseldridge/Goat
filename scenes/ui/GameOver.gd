extends CanvasLayer

export(String) var retryScene = ""
onready var messageBroker = MessageBroker

func Show():
	visible = true
	$Backing/Fill/HBoxContainer/RetryButton.grab_focus()
	
func Hide():
	visible = false

func _on_RetryButton_pressed():
	messageBroker.emit_signal("load_level", retryScene)
 
func _on_QuitButton_pressed():
	messageBroker.emit_signal("load_level", "-1") # load the world select screen
	Hide()
