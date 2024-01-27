extends CanvasLayer

onready var messageBroker = MessageBroker
onready var settings = PlayerSettings

# Main menu items
onready var playPopup = $PlayPopup
onready var settingsPopup = $SettingsPopup
onready var playButton = $VBoxContainer/PlayButton
onready var settingsButton = $VBoxContainer/SettingsButton
onready var quitButton = $VBoxContainer/QuitButton

# Save game select
var slots = {}

# Settings
onready var settingsBackButton = $SettingsPopup/BackButton
onready var musicVolumeLabel = $SettingsPopup/ColorRect/Control/Music/HFlowContainer/VolumeLabel
onready var musicMinusButton = $SettingsPopup/ColorRect/Control/Music/HFlowContainer/MinusButton
onready var sfxVolumeLabel = $SettingsPopup/ColorRect/Control/SFX/HFlowContainer/VolumeLabel
onready var sfxMinusButton = $SettingsPopup/ColorRect/Control/SFX/HFlowContainer/MinusButton

func _ready():
	playButton.grab_focus()
	
	# set up the play popup
	$PlayPopup/BackButton.focus_neighbour_right = $PlayPopup/BackButton.get_path_to($PlayPopup/ColorRect/Control/PlaySlots/Slot1)
	for saveSlot in [
		{ "file": "player1", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot1" },
		{ "file": "player2", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot2" },
		{ "file": "player3", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot3" }]:
		var button = get_node(saveSlot.button)
		button.focus_neighbour_left = button.get_path_to($PlayPopup/BackButton)
		var playerFile = File.new()
		var playerFilePath = "user://" + saveSlot.file + ".json"
		
		button.connect("pressed", self, "_on_UserSlotSelected", [saveSlot.file])
		
		if playerFile.file_exists(playerFilePath):
			playerFile.open(playerFilePath, File.READ)
			var data = parse_json(playerFile.get_as_text())
			playerFile.close()
			button.SetUp(data)
		else:
			button.SetUp(null)
	
	# set up settings menu
	settingsBackButton.focus_neighbour_right = settingsBackButton.get_path_to(musicMinusButton)
	musicMinusButton.focus_neighbour_left = musicMinusButton.get_path_to(settingsBackButton)
	sfxMinusButton.focus_neighbour_left = sfxMinusButton.get_path_to(settingsBackButton)


func _on_PlayButton_pressed():
	playPopup.popup()


func _on_UserSlotSelected(userFile):
	messageBroker.emit_signal("selected_user_file", userFile)


func _on_SettingsButton_pressed():
	musicVolumeLabel.text = str(int(settings.musicVolume))
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	settingsPopup.popup()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	settings.Save()
	playPopup.hide()
	settingsPopup.hide()


func _on_Volume_MinusButton_pressed():
	settings.musicVolume -= 5
	if settings.musicVolume < 0:
		settings.musicVolume = 0
	musicVolumeLabel.text = str(int(settings.musicVolume))


func _on_Volume_PlusButton_pressed():
	settings.musicVolume += 5
	if settings.musicVolume > 100:
		settings.musicVolume = 100
	musicVolumeLabel.text = str(int(settings.musicVolume))


func _on_SFX_MinusButton_pressed():
	settings.sfxVolume -= 5
	if settings.sfxVolume < 0:
		settings.sfxVolume = 0
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	settings.TestSfx()


func _on_SFX_PlusButton_pressed():
	settings.sfxVolume += 5
	if settings.sfxVolume > 100:
		settings.sfxVolume = 100
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	settings.TestSfx()
