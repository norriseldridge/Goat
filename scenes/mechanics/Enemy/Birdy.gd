extends Node2D

export var speed = 40
var moveTowardsBegin = false
onready var body = $KinematicBody2D
onready var begin = $StartPoint
onready var end = $EndPoint
onready var visual = $KinematicBody2D/AnimatedSprite

func _physics_process(delta):
	var movement = Vector2()
	if moveTowardsBegin:
		movement = body.position.direction_to(begin.position)
		if body.position.distance_to(begin.position) <= 1:
			moveTowardsBegin = false
	else:
		movement = body.position.direction_to(end.position)
		if body.position.distance_to(end.position) <= 1:
			moveTowardsBegin = true
	if movement.x <= -0.5:
		visual.flip_h = true
	elif movement.x >= -0.5:
		visual.flip_h = false
	body.position = body.position + (movement * speed * delta)
