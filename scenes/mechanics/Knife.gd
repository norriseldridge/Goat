extends KinematicBody2D

export (float) var speed = 1.0
var movement = Vector2.LEFT

func _physics_process(delta):
	position += (movement * speed * delta)
