extends Node2D

onready var animation = $Animation
onready var timer = $Timer
onready var killZone = $KillZone
export var state = false


func _ready():
	timer.connect("timeout", self, "next_state")
	next_state()

func next_state():
	if !state:
		animation.play("Start")
		state = true
	else:
		killZone.monitoring = false
		animation.play("End")
		state = false

func _on_Animation_animation_finished():
	if state:
		animation.play("Loop")
		killZone.monitoring = true