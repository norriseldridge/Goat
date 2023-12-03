extends AnimatedSprite

onready var worldLabel = $Label
var worldData

func SetWorldData(data):
	worldData = data
	worldLabel.text = worldData.name
