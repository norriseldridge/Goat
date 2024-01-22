extends Button

onready var messageBroker = MessageBroker
onready var nameLabel = $HBoxContainer/LevelName
onready var scoreLabel = $HBoxContainer/HighScore
onready var timeLabel = $HBoxContainer/FastestTime

var levelId = ""
var levelMusic = ""
var levelName = ""
var highScore
var fastestTime
var completed = false
var current = false

func _ready():
	nameLabel.text = levelName

	if completed:
		scoreLabel.text = "Score " + str(highScore)
		timeLabel.text = time_convert(fastestTime)
	else:
		scoreLabel.text = "Score N/A"
		timeLabel.text = "N/A"
	
	if !completed and !current:
		disabled = true
		nameLabel.text = "???"
	
	if current:
		grab_focus()

func _on_LevelSelectItem_pressed():
	messageBroker.emit_signal("load_level", levelId)

func time_convert(time_elapsed):	
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var milliseconds = fmod(time_elapsed, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
