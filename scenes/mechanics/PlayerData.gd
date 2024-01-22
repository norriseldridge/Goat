extends Node

# permanent data
export(String) var playerFileName = "player1"
export(String) var currentLevel = "1"
export(String) var lastUnlockedLevel = "1"
var completedLevels = []
var levelHighScores = {}
var levelFastestTimes = {}
var lastPlayed = null

func Load():
	var json_file = File.new()
	var filePath = GetUserFilePath()
	if json_file.file_exists(filePath):
		json_file.open(filePath, File.READ)
		var raw_data = parse_json(json_file.get_as_text())
		json_file.close()
		
		currentLevel = raw_data.currentLevel
		lastUnlockedLevel = raw_data.lastUnlockedLevel
		completedLevels = raw_data.completedLevels
		levelHighScores = raw_data.levelHighScores
		levelFastestTimes = raw_data.levelFastestTimes
	
func Save():
	var json_file = File.new()
	var filePath = GetUserFilePath()
	json_file.open(filePath, File.WRITE)
	var raw_data = {
		"currentLevel": currentLevel,
		"lastUnlockedLevel": lastUnlockedLevel,
		"completedLevels": completedLevels,
		"levelHighScores": levelHighScores,
		"levelFastestTimes": levelFastestTimes,
		"lastPlayed": OS.get_datetime()
	}
	json_file.store_line(to_json(raw_data))
	json_file.close()

func MarkLevelCompleted(levelScore, levelTime):
	if !completedLevels.has(currentLevel):
		completedLevels.append(currentLevel)
	
	if !levelHighScores.has(currentLevel) or levelHighScores[currentLevel] < levelScore:
		levelHighScores[currentLevel] = levelScore

	if !levelFastestTimes.has(currentLevel) or levelFastestTimes[currentLevel] > levelTime:
		levelFastestTimes[currentLevel] = levelTime

func GetUserFilePath():
	return "user://" + playerFileName + ".json"
