extends KinematicBody2D

var shouldShake = false
var shouldFall = false
var angle = 0
onready var sprite = $Sprite
export(float) var shakeTime = 2
export var shakeSpeed = 10
export var shakeAmount = 10
var movement = Vector2(0, 1)
export var fallSpeed = 80

func _process(delta):
	if shouldShake:
		if shakeTime > 0:
			shakeTime = shakeTime - delta
			angle = angle + (delta * shakeSpeed)
			sprite.rotation_degrees = sin(angle) * shakeAmount
		else:
			shouldFall = true
	
	if shouldFall:
		position = position + (movement * fallSpeed * delta)

func _on_Area2D_body_entered(body):
	shouldShake = true
