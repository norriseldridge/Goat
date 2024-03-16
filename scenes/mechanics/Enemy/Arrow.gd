extends Node2D

export var riseSpeed = 70
export var fallSpeed = 120
onready var background = $Background
onready var arrow = $Arrow
onready var killZone = $KillZone

func _ready():
	reset()

func reset():
	background.visible = true
	arrow.visible = false
	killZone.monitoring = false

func _physics_process(delta):
	var movement = Vector2()
	if position.y > -12 && background.visible:
		movement.y = -riseSpeed
	else:
		if background.visible:
			background.visible = false
			arrow.visible = true
			killZone.monitoring = true
		movement.y = fallSpeed
	position = position + (movement * delta)
