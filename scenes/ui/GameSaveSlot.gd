extends Button

onready var levelUtility = LevelUtility
onready var newGameLabel = $NewGameLabel
onready var saveData = $SaveData
onready var worldLabel = $SaveData/WorldLabel
onready var lastPlayedLabel = $SaveData/LastPlayedLabel
onready var timePlayedLabel = $SaveData/TimePlayedLabel
onready var deathsLabel = $SaveData/DeathsLabel

func SetUp(playerData):
	if playerData == null:
		saveData.visible = false
		return
	
	newGameLabel.visible = false
	worldLabel.text = levelUtility.GetCurrentWorldName(playerData)

	var date = playerData.lastPlayed
	var hour = date.hour
	var amPm = "AM"
	if hour > 12:
		hour -= 12
		amPm = "PM"
	lastPlayedLabel.text = "%s/%s/%s %s:%s%s" % [date.month, date.day, date.year, hour, date.minute, amPm]

	var timePlayed = playerData.totalSecondsPlayed
	timePlayedLabel.text = "Time Played: " + time_convert(timePlayed)

	deathsLabel.text = "Deaths: " + str(playerData.totalDeaths)


func time_convert(time_elapsed):	
	var seconds = fmod(time_elapsed, 60)
	var minutes = fmod((time_elapsed/60), 60)
	var hours = (time_elapsed/60)/60
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
