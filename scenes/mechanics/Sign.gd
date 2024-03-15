extends Area2D

onready var dialogue = $Dialogue

func _process(_delta):
	if get_overlapping_bodies().size() > 0:
		if Input.is_action_just_pressed("ui_accept"):
			if !dialogue.visible:
				dialogue.Show()
	else:
		if dialogue.visible:
			dialogue.visible = false
