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
var maxCharDelay = 1.0
var speed = 100.0

var colorPushMap = {}
var waitMap = {}
var speedMap = {}

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
	text.text = ""
	index = 0
	set_next_text()
	visible = true

func _process(delta):
	if !visible:
		return

	if nextText != null:
		charDelay += speed * delta
		if charDelay >= maxCharDelay:
			charDelay = 0.0
			if charIndex < nextText.length():
				if !sound.playing && nextText[charIndex] != ' ':
					sound.pitch_scale = rng.randf_range(1.0, 1.1)
					sound.play()

				if colorPushMap.has(charIndex):
					# print(text.text)
					text.push_color(colorPushMap[charIndex])
					# print("changing color")

				if waitMap.has(charIndex):
					# print(text.text)
					# print("wait for " + str(waitMap[charIndex]) + " seconds!")
					charDelay = -waitMap[charIndex]

				if speedMap.has(charIndex):
					# print(text.text)
					# print("index " + str(charIndex) + " set speed to " + str(speedMap[charIndex]) + ", text: " + text.text)
					speed = float(speedMap[charIndex])

				text.append_bbcode(nextText[charIndex])
				charIndex += 1
			else:
				nextText = null

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
	colorPushMap.clear()
	waitMap.clear()
	speedMap.clear()

	var checkCount = 1000
	while checkCount > 0:
		checkCount -= 1 # ensure we don't loop forever

		var waitIndex = nextText.findn("[wait=")
		var speedIndex = nextText.findn("[speed=")
		var colorIndex = nextText.findn("[color=blue]")
		var colorEndIndex = nextText.findn("[/color]")

		if waitIndex == -1 && speedIndex == -1 && colorIndex == -1 && colorEndIndex == -1:
			break

		var allIndexes = [waitIndex, speedIndex, colorIndex, colorEndIndex]

		if is_smallest_positive_number(waitIndex, allIndexes):
			var i = waitIndex
			var endI = nextText.findn("]", i)
			var length = (endI - i) - 6
			var value = nextText.substr(i + 6, length)
			waitMap[i] = float(value)
			nextText.erase(i, length + 7)
		elif is_smallest_positive_number(speedIndex, allIndexes):
			var i = speedIndex
			var endI = nextText.findn("]", i)
			var length = (endI - i) - 7
			var value = nextText.substr(i + 7, length)
			speedMap[i] = float(value)
			nextText.erase(i, length + 8)
		elif is_smallest_positive_number(colorIndex, allIndexes):
			var i = colorIndex
			colorPushMap[i] = Color.blue
			nextText.erase(i, 12)
		elif is_smallest_positive_number(colorEndIndex, allIndexes):
			var i = colorEndIndex
			colorPushMap[i] = Color.white
			nextText.erase(i, 8)
		else:
			break

func is_smallest_positive_number(number: int, numbers: Array):
	if number < 0:
		return false

	for temp in numbers:
		if temp < 0:
			continue

		if number > temp:
			return false
	return true
