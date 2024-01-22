extends Control

onready var keysLabel = $KeysLabel
onready var scoreLabel = $ScoreLabel

func set_keys(keys):
	keysLabel.text = "Keys " + str(keys)

func set_score(score):
	scoreLabel.text = "Score " + str(score)
