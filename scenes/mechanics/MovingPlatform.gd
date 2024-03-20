extends Node2D

export var speed = 20
var moveTowardsBegin = false
onready var platform = $Platform
onready var begin = $Begin
onready var end = $End

func _physics_process(delta):
	var movement = Vector2()
	if moveTowardsBegin:
		movement = platform.position.direction_to(begin.position)
		if platform.position.distance_to(begin.position) <= 0.5:
			platform.position = begin.position
			moveTowardsBegin = false
	else:
		movement = platform.position.direction_to(end.position)
		if platform.position.distance_to(end.position) <= 0.5:
			platform.position = end.position
			moveTowardsBegin = true
	# platform.move_and_collide(movement * speed * delta)
	platform.position = platform.position + (movement * speed * delta)
