extends Node

# temporary state
var coins = 0
var keys = 0

# permanent data
export(String) var playerFileName = "player1"
export(String) var currentLevel = "1"
var levelScores = {}

func ResetState(levelId):
	coins = 0
	keys = 0
	# NOTE: don't set this from saved data at all because the point
	# is to let users try to level again, do better, save that score

func Load():
	var json_file = File.new()
	var filePath = GetUserFilePath()
	if json_file.file_exists(filePath):
		json_file.open(filePath, File.READ)
		var raw_data = parse_json(json_file.get_as_text())
		json_file.close()
		
		currentLevel = raw_data.currentLevel
		levelScores = raw_data.levelScores
	
func Save():
	var json_file = File.new()
	var filePath = GetUserFilePath()
	json_file.open(filePath, File.WRITE)
	var raw_data = {
		"currentLevel": currentLevel,
		"levelScores": levelScores
	}
	json_file.store_line(to_json(raw_data))
	json_file.close()

func SaveLevelScore():
	if levelScores.has(currentLevel):
		if levelScores[currentLevel] > coins:
			return # DON'T save a score lower than the highest
	levelScores[currentLevel] = coins

func GetUserFilePath():
	return "user://" + playerFileName + ".json"
