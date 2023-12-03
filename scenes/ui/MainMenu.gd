extends CanvasLayer

onready var messageBroker = MessageBroker

onready var playPopup = $PlayPopup
onready var settingsPopup = $SettingsPopup
onready var playButton = $VBoxContainer/PlayButton
onready var settingsButton = $VBoxContainer/SettingsButton
onready var quitButton = $VBoxContainer/QuitButton

var slots = {}

func _ready():
	playButton.grab_focus()
	
	# set up the play popup
	$PlayPopup/BackButton.focus_neighbour_right = $PlayPopup/BackButton.get_path_to($PlayPopup/ColorRect/PlaySlots/Slot1)
	for saveSlot in [
		{ "file": "player1", "button": "PlayPopup/ColorRect/PlaySlots/Slot1" },
		{ "file": "player2", "button": "PlayPopup/ColorRect/PlaySlots/Slot2" },
		{ "file": "player3", "button": "PlayPopup/ColorRect/PlaySlots/Slot3" },
		{ "file": "player4", "button": "PlayPopup/ColorRect/PlaySlots/Slot4" },
		{ "file": "player5", "button": "PlayPopup/ColorRect/PlaySlots/Slot5" }]:
		var button = get_node(saveSlot.button)
		button.focus_neighbour_left = button.get_path_to($PlayPopup/BackButton)
		var playerFile = File.new()
		var playerFilePath = "user://" + saveSlot.file + ".json"
		
		button.connect("pressed", self, "_on_UserSlotSelected", [saveSlot.file])
		
		if playerFile.file_exists(playerFilePath):
			playerFile.open(playerFilePath, File.READ)
			var data = parse_json(playerFile.get_as_text())
			playerFile.close()
			var ld = data.lastPlayed
			button.text = "Last played: %s/%s/%s %s:%s:%s" % [ld.day, ld.month, ld.year, ld.hour, ld.minute, ld.second]
		else:
			button.text = "New Game"


func _on_PlayButton_pressed():
	playPopup.popup()


func _on_UserSlotSelected(userFile):
	messageBroker.emit_signal("selected_user_file", userFile)


func _on_SettingsButton_pressed():
	settingsPopup.popup()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	playPopup.hide()
	settingsPopup.hide()
