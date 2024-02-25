extends CanvasLayer

export(String) var dialogueFile = "res://data/dialogue.json"
export (String) var id

onready var messageBroker = MessageBroker
onready var settings = PlayerSettings

onready var text = $Border/ColorRect/RichTextLabel
onready var sound = $AudioStreamPlayer
var data = null
var currentDialogue = null
var index = 0
var charIndex = 0
var nextText = null
var charDelay = 0
var maxCharDelay = 0.01

var colorPushMap = {}

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
	set_next_text()

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

				if colorPushMap.has(charIndex):
					text.push_color(colorPushMap[charIndex])

				text.append_bbcode(nextText[charIndex])
				charIndex += 1
			else:
				nextText = null
				colorPushMap.clear()

	if Input.is_action_just_pressed("ui_accept"):
		if nextText != null:
			text.text = ""

			if !colorPushMap.empty():
				var keys = colorPushMap.keys()
				keys.invert()
				for key in keys:
					nextText = nextText.insert(key, "[color=blue]" if colorPushMap[key] == Color.blue else "[/color]")

			text.append_bbcode(nextText)
			nextText = null
		else:
			index += 1
			if index < currentDialogue.size():
				text.text = ""
				set_next_text()
				charIndex = 0
			else:
				visible = false
				messageBroker.emit_signal("dialogue_complete")

func set_next_text():
	nextText = currentDialogue[index]

	var i = nextText.findn("[color=blue]")
	if i >= 0:
		colorPushMap[i] = Color.blue
		nextText = nextText.replace("[color=blue]", "")

	i = nextText.findn("[/color]", i)
	if i >= 0:
		colorPushMap[i] = Color.white
		nextText = nextText.replace("[/color]", "")
