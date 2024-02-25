extends Node2D

onready var end = $End
onready var speed = 10
export var swayAmount = 2.0
var sway = 0.0
var startPosition = Vector2.ZERO


func _ready():
	startPosition = position


func _physics_process(delta):
	sway += delta
	position.y = startPosition.y + swayAmount * sin(sway)

	var movement = position.direction_to(end.position)
	position += (movement * speed * delta)