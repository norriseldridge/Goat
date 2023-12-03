extends Control

onready var keysLabel = $KeysLabel

func set_keys(keys):
	keysLabel.text = "Keys " + str(keys)
