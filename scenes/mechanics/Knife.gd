extends KinematicBody2D

export (float) var speed = 1.0
onready var sprite = $Knife
var movement = Vector2.LEFT

func _physics_process(delta):
	position += (movement * speed * delta)
	sprite.flip_h = movement.x > 0
