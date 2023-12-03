extends Node

# permanent data
export(String) var playerFileName = "player1"
export(String) var currentLevel = "1"
var completedLevels = []
var lastPlayed = null

func Load():
	var json_file = File.new()
	var filePath = GetUserFilePath()
	if json_file.file_exists(filePath):
		json_file.open(filePath, File.READ)
		var raw_data = parse_json(json_file.get_as_text())
		json_file.close()
		
		currentLevel = raw_data.currentLevel
		completedLevels = raw_data.completedLevels
	
func Save():
	var json_file = File.new()
	var filePath = GetUserFilePath()
	json_file.open(filePath, File.WRITE)
	var raw_data = {
		"currentLevel": currentLevel,
		"completedLevels": completedLevels,
		"lastPlayed": OS.get_datetime()
	}
	json_file.store_line(to_json(raw_data))
	json_file.close()

func MarkLevelCompleted():
	if !completedLevels.has(currentLevel):
		completedLevels.append(currentLevel)

func GetUserFilePath():
	return "user://" + playerFileName + ".json"
