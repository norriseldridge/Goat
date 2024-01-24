extends Control

onready var keysLabel = $KeysLabel
onready var scoreLabel = $ScoreLabel
onready var timeLabel = $TimeLabel

func set_keys(keys):
	keysLabel.text = "Keys " + str(keys)

func set_score(score):
	scoreLabel.text = "Score " + str(score)

func set_time(seconds):
	timeLabel.text = time_convert(seconds)

func time_convert(time_elapsed):	
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var milliseconds = fmod(time_elapsed, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]