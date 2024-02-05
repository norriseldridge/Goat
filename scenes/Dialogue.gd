extends CanvasLayer

export(String) var dialogueFile = "res://data/dialogue.json"
export (String) var id

onready var settings = PlayerSettings

onready var text = $Border/ColorRect/RichTextLabel
onready var sound = $AudioStreamPlayer
var data = null
var currentDialogue = null
var index = 0
var charIndex = 0
var nextText = null
var charDelay = 0
var maxCharDelay = 0.02

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	sound.volume_db = settings.GetSFXVolume()

	visible = false
	var file = File.new()
	file.open(dialogueFile, File.READ)
	data = parse_json(file.get_as_text())
	file.close()
	currentDialogue = data[id]

func Show():
	visible = true
	text.text = ""
	nextText = currentDialogue[index]

func _process(delta):
	if !visible:
		return

	if nextText != null:
		charDelay += delta
		if charDelay >= maxCharDelay:
			charDelay = 0
			if charIndex < nextText.length():
				if !sound.playing && nextText[charIndex] != ' ':
					sound.pitch_scale = rng.randf_range(1.0, 1.1)
					sound.play()

				text.text += nextText[charIndex]
				charIndex += 1
			else:
				nextText = null

	if Input.is_action_just_pressed("ui_accept"):
		if nextText != null:
			text.text = nextText
			nextText = null
		else:
			index += 1
			if index < currentDialogue.size():
				text.text = ""
				nextText = currentDialogue[index]
				charIndex = 0
			else:
				visible = false
