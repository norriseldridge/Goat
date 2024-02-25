extends Node2D

const GRAVITY = 300
const MAX_GRAVITY = 150

export var shootForce = 200
onready var body = $KinematicBody2D
var initalY = 0
var velocity = Vector2.ZERO


func _ready():
	initalY = body.position.y


func _process(delta):
	if body.position.y > initalY:
		body.position.y = initalY
	else:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY

func _physics_process(delta):
	body.position += velocity * delta

func _on_Timer_timeout():
	velocity.y = -shootForce
