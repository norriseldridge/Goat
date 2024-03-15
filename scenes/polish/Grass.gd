extends Node2D

onready var animation = $AnimatedSprite
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	timer.start()

func reset():
	timer.wait_time = rand_range(1.0, 2.0)

func _on_Timer_timeout():
	animation.frame = 0
	animation.play()
