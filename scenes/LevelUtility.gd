extends Node

export(String) var levelFile = "res://data/levels.json"
var level_data = null

func _ready():
	var file = File.new()
	file.open(levelFile, File.READ)
	level_data = parse_json(file.get_as_text())
	file.close()

func GetLevelData(levelId):
	for level in level_data["levels"]:
		if level.id == levelId:
			return level
	return null

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
	
func GetWorldDataById(id):
	for world in level_data["worlds"]:
		if world.id == id:
			return world
	return null
	
func GetWorldComplete(worldData, playerData):
	if worldData["levels"].size() == 0:
		return false
		
	for level in worldData["levels"]:
		if !playerData.completedLevels.has(level):
			return false
	return true

func GetWorldUnlocked(worldData, playerData):
	if worldData.prereqid == "-1":
		return true
	
	var previousWorldData = GetWorldDataById(worldData.prereqid)
	return GetWorldComplete(previousWorldData, playerData)
