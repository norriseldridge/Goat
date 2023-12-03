extends Node

export(String) var levelFile = "res://data/levels.json"
var level_data = null

func _ready():
	var file = File.new()
	file.open(levelFile, File.READ)
	level_data = parse_json(file.get_as_text())

func GetScene(levelId):
	for level in level_data["levels"]:
		if level.id == levelId:
			return level.scene
	return null

func GetNextLevel(levelId):
	for level in level_data["levels"]:
		if level.id == levelId:
			return level.next
	return null

func GetWorldData():
	return level_data["worlds"]
	
func GetWorldComplete(worldData, playerData):
	for level in worldData["levels"]:
		if !playerData.completedLevels.has(level):
			return false
	return true
