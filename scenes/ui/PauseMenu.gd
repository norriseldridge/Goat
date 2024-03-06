extends CanvasLayer

export(String) var retryScene = ""
onready var messageBroker = MessageBroker

func _ready():
	$Backing/Fill/HBoxContainer/RetryButton.connect("mouse_entered", self, "_on_mouse_enter", [$Backing/Fill/HBoxContainer/RetryButton])
	$Backing/Fill/HBoxContainer/QuitButton.connect("mouse_entered", self, "_on_mouse_enter", [$Backing/Fill/HBoxContainer/QuitButton])

func Show():
	visible = true
	$Backing/Fill/HBoxContainer/RetryButton.grab_focus()
	
func Hide():
	visible = false

func _on_mouse_enter(button):
	button.grab_focus()

func _on_RetryButton_pressed():
	messageBroker.emit_signal("load_level", retryScene, true)
 
func _on_QuitButton_pressed():
	messageBroker.emit_signal("load_level", "-1") # load the world select screen
	Hide()
