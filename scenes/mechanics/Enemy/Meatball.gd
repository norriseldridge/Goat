extends Node2D

export var riseSpeed = 20
export var fallSpeed = 20
export var rotationSpeed = 3
onready var backgroundMeatball = $BackgroundMeatball
onready var meatball = $Meatball
onready var killZone = $KillZone

func _ready():
	reset()

func reset():
	backgroundMeatball.visible = true
	meatball.visible = false
	killZone.monitoring = false

func _physics_process(delta):
	backgroundMeatball.rotate(rotationSpeed * delta)
	meatball.rotate(rotationSpeed * delta)
	var movement = Vector2()
	if position.y > -12 && backgroundMeatball.visible:
		movement.y = -riseSpeed
	else:
		if backgroundMeatball.visible:
			backgroundMeatball.visible = false
			meatball.visible = true
			killZone.monitoring = true
		movement.y = fallSpeed
	position = position + (movement * delta)
