extends KinematicBody2D


onready var sprite = $AnimatedSprite

func kill():
	sprite.play("Burn")
