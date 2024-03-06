extends CanvasLayer

onready var messageBroker = MessageBroker
onready var settings = PlayerSettings

onready var changeSfx = $AudioStreamPlayer2D

# Main menu items
onready var playPopup = $PlayPopup
onready var settingsPopup = $SettingsPopup
onready var playButton = $VBoxContainer/PlayButton
onready var settingsButton = $VBoxContainer/SettingsButton
onready var quitButton = $VBoxContainer/QuitButton

# Save game select
onready var playBackButton = $PlayPopup/BackButton
var slots = {}

# Settings
onready var settingsBackButton = $SettingsPopup/BackButton
onready var musicVolumeLabel = $SettingsPopup/ColorRect/Control/Music/HFlowContainer/VolumeLabel
onready var musicMinusButton = $SettingsPopup/ColorRect/Control/Music/HFlowContainer/MinusButton
onready var musicPlusButton = $SettingsPopup/ColorRect/Control/Music/HFlowContainer/PlusButton
onready var sfxVolumeLabel = $SettingsPopup/ColorRect/Control/SFX/HFlowContainer/VolumeLabel
onready var sfxMinusButton = $SettingsPopup/ColorRect/Control/SFX/HFlowContainer/MinusButton
onready var sfxPlusButton = $SettingsPopup/ColorRect/Control/SFX/HFlowContainer/PlusButton
onready var autoRetryCheckbox = $SettingsPopup/ColorRect/Control/AutoRetry/CheckBox
onready var autoRetryBorder = $SettingsPopup/ColorRect/Control/AutoRetry/ActiveBorder

func _ready():
	playButton.grab_focus()

	for tempButton in [playButton, settingsButton, quitButton]:
		tempButton.connect("focus_entered", self, "_on_focus", [tempButton])

	for tempButton in [playButton, settingsButton, quitButton, playBackButton, settingsBackButton,
		musicMinusButton, musicPlusButton, sfxMinusButton, sfxPlusButton, autoRetryCheckbox]:
		tempButton.connect("mouse_entered", self, "_on_mouse_enter", [tempButton])

	# set up the play popup
	playBackButton.focus_neighbour_right = playBackButton.get_path_to($PlayPopup/ColorRect/Control/PlaySlots/Slot1)
	for saveSlot in [
		{ "file": "player1", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot1" },
		{ "file": "player2", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot2" },
		{ "file": "player3", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot3" }]:
		var button = get_node(saveSlot.button)
		button.focus_neighbour_left = button.get_path_to($PlayPopup/BackButton)
		
		button.connect("mouse_entered", self, "_on_mouse_enter", [button])
		button.connect("focus_entered", self, "_on_focus", [button])

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
	autoRetryCheckbox.focus_neighbour_left = autoRetryCheckbox.get_path_to(settingsBackButton)
	autoRetryBorder.visible = false


func _on_mouse_enter(button):
	button.grab_focus()


func _on_focus(button):
	changeSfx.volume_db = settings.GetSFXVolume()
	changeSfx.play()


func _on_PlayButton_pressed():
	playPopup.popup()


func _on_UserSlotSelected(userFile):
	messageBroker.emit_signal("selected_user_file", userFile)


func _on_SettingsButton_pressed():
	musicVolumeLabel.text = str(int(settings.musicVolume))
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	autoRetryCheckbox.pressed = settings.autoRetry
	settingsPopup.popup()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	settings.autoRetry = autoRetryCheckbox.pressed
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


func _on_AutoRetry_focus_entered():
	autoRetryBorder.visible = true


func _on_AutoRetry_focus_exited():
	autoRetryBorder.visible = false
