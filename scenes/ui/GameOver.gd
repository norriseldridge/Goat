extends CanvasLayer

export(String) var retryScene = ""
onready var messageBroker = MessageBroker
onready var settings = PlayerSettings
onready var retryTimer = $RetryTimer

func _ready():
	retryTimer.connect("timeout", self, "_on_RetryButton_pressed")

func Show():
	if settings.autoRetry:
		retryTimer.wait_time = 0.5
		retryTimer.start()
		return

	visible = true
	$Backing/Fill/HBoxContainer/RetryButton.grab_focus()
	
func Hide():
	visible = false

func _on_RetryButton_pressed():
	messageBroker.emit_signal("load_level", retryScene, true)
 
func _on_QuitButton_pressed():
	messageBroker.emit_signal("load_level", "-1") # load the world select screen
	Hide()
