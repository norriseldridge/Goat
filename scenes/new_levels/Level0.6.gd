extends Node2D


onready var goatDialogue = $GoatDialogue

var shownGoatDialogue = false


func _on_GoatDialogueTrigger_body_entered(_body:Node):
	if !shownGoatDialogue:
		goatDialogue.Show()
		shownGoatDialogue = true
