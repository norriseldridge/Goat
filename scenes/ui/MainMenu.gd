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
onready var autoRetryCheckboxButton = $SettingsPopup/ColorRect/Control/AutoRetry/Container/CheckBoxButton
onready var autoRetryBorder = $SettingsPopup/ColorRect/Control/AutoRetry/Container/ActiveBorder

onready var notCheckedTexture = load("res://sprites/Checkbox_unchecked.png")
onready var checkedTexture = load("res://sprites/Checkbox_checked.png")

var previousButton = null
var activeButton = null
var activeButtonScaleAmount = 0.015
var activeButtonScaleSpeed = 8 # 4.5
var activeButtonScale = 0.0
var shouldMakeSound = false

func _ready():
	
	for tempButton in [playButton, settingsButton, quitButton, playBackButton, settingsBackButton,
		musicMinusButton, musicPlusButton, sfxMinusButton, sfxPlusButton, autoRetryCheckboxButton]:
		tempButton.connect("mouse_entered", self, "_on_mouse_enter", [tempButton])
		tempButton.connect("focus_entered", self, "_on_focus", [tempButton])

	playButton.grab_focus()

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
	autoRetryCheckboxButton.focus_neighbour_left = autoRetryCheckboxButton.get_path_to(settingsBackButton)
	autoRetryBorder.visible = false

func resetPlayerSlots():
	for saveSlot in [
		{ "file": "player1", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot1" },
		{ "file": "player2", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot2" },
		{ "file": "player3", "button": "PlayPopup/ColorRect/Control/PlaySlots/Slot3" }]:
		var button = get_node(saveSlot.button)
		var playerFile = File.new()
		var playerFilePath = "user://" + saveSlot.file + ".json"
		
		if playerFile.file_exists(playerFilePath):
			playerFile.open(playerFilePath, File.READ)
			var data = parse_json(playerFile.get_as_text())
			playerFile.close()
			button.SetUp(data)
		else:
			button.SetUp(null)

func _process(delta):
	shouldMakeSound = true
	if activeButton != null:
		activeButtonScale += delta
		activeButton.rect_scale = Vector2.ONE * (1.0 + activeButtonScaleAmount + (activeButtonScaleAmount * sin(activeButtonScale * activeButtonScaleSpeed)))


func _on_mouse_enter(button):
	button.grab_focus()


func _on_focus(button):
	if shouldMakeSound:
		changeSfx.volume_db = settings.GetSFXVolume()
		changeSfx.play()

	if activeButton != button:

		if previousButton != activeButton:
			previousButton = activeButton
			if previousButton != null:
				previousButton.rect_scale = Vector2.ONE
		
		activeButton = button
		activeButton.rect_pivot_offset = activeButton.rect_size / 2.0


func _on_PlayButton_pressed():
	playPopup.popup()


func _on_UserSlotSelected(userFile):
	messageBroker.emit_signal("selected_user_file", userFile)


func _on_SettingsButton_pressed():
	musicVolumeLabel.text = str(int(settings.musicVolume))
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	# autoRetryCheckbox.pressed = settings.autoRetry
	set_checkbox_state(settings.autoRetry)
	settingsPopup.popup()


func _on_QuitButton_pressed():
	get_tree().quit()

func _on_ClearDataButton_pressed():
	var dir = Directory.new()
	var playerFile = File.new()
	for file in ["player1", "player2", "player3"]:
		var playerFilePath = "user://" + file + ".json"
		if playerFile.file_exists(playerFilePath):
			dir.remove(playerFilePath)
	resetPlayerSlots()


func _on_BackButton_pressed():
	# settings.autoRetry = autoRetryCheckbox.pressed
	settings.Save()
	playPopup.hide()
	settingsPopup.hide()


func _on_Volume_MinusButton_pressed():
	settings.musicVolume -= 5
	if settings.musicVolume < 0:
		settings.musicVolume = 0
	musicVolumeLabel.text = str(int(settings.musicVolume))
	changeSfx.play()


func _on_Volume_PlusButton_pressed():
	settings.musicVolume += 5
	if settings.musicVolume > 100:
		settings.musicVolume = 100
	musicVolumeLabel.text = str(int(settings.musicVolume))
	changeSfx.play()


func _on_SFX_MinusButton_pressed():
	settings.sfxVolume -= 5
	if settings.sfxVolume < 0:
		settings.sfxVolume = 0
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	changeSfx.volume_db = settings.GetSFXVolume()
	changeSfx.play()


func _on_SFX_PlusButton_pressed():
	settings.sfxVolume += 5
	if settings.sfxVolume > 100:
		settings.sfxVolume = 100
	sfxVolumeLabel.text = str(int(settings.sfxVolume))
	changeSfx.volume_db = settings.GetSFXVolume()
	changeSfx.play()


func _on_AutoRetry_focus_entered():
	autoRetryBorder.visible = true

func _on_AutoRetry_focus_exited():
	autoRetryBorder.visible = false

func set_checkbox_state(checked: bool):
	autoRetryCheckboxButton.texture_normal = checkedTexture if checked else notCheckedTexture

func _on_CheckBoxButton_pressed():
	settings.autoRetry = !settings.autoRetry
	set_checkbox_state(settings.autoRetry)
