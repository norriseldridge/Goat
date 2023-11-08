extends Control

onready var scoreLabel = $ScoreLabel
onready var keysLabel = $KeysLabel

func set_keys(keys):
	keysLabel.text = "Keys " + str(keys)

func set_score(score):
	scoreLabel.text = "Score " + str(score)
