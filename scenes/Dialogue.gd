extends CanvasLayer

export(String) var dialogueFile = "res://data/dialogue.json"
export (String) var id

onready var text = $Border/ColorRect/RichTextLabel
var data = null
var currentDialogue = null
var index = 0

func _ready():
	visible = false
	var file = File.new()
	file.open(dialogueFile, File.READ)
	data = parse_json(file.get_as_text())
	file.close()
	currentDialogue = data[id]

func Show():
	visible = true
	text.text = currentDialogue[index]

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		index += 1
		if index < currentDialogue.size():
			text.text = currentDialogue[index]
		else:
			visible = false