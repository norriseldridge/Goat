extends Node

export(String) var fileName = "settings"
export(int) var musicVolume = 100
export(int) var sfxVolume = 100
export(bool) var autoRetry = false
onready var sfxTest = $SFXTest

func Load():
	var json_file = File.new()
	var filePath = GetSettingsFilePath()
	if json_file.file_exists(filePath):
		json_file.open(filePath, File.READ)
		var raw_data = parse_json(json_file.get_as_text())
		json_file.close()
		
		musicVolume = raw_data.musicVolume
		sfxVolume = raw_data.sfxVolume
		autoRetry = raw_data.autoRetry
	
func Save():
	var json_file = File.new()
	var filePath = GetSettingsFilePath()
	json_file.open(filePath, File.WRITE)
	var raw_data = {
		"musicVolume": musicVolume,
		"sfxVolume": sfxVolume,
		"autoRetry": autoRetry
	}
	json_file.store_line(to_json(raw_data))
	json_file.close()

func TestSfx():
	sfxTest.volume_db = GetSFXVolume()
	sfxTest.play()

func GetSettingsFilePath():
	return "user://" + fileName + ".json"

func GetMusicVolume():
	return linear2db(musicVolume / 1000.0)

func GetSFXVolume():
	return linear2db(sfxVolume / 1000.0)
