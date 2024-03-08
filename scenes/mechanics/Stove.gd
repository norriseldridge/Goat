extends Node2D

onready var settings = PlayerSettings
onready var animation = $Animation
onready var timer = $Timer
onready var killZone = $KillZone
onready var sfx = $AudioStreamPlayer
export var state = false
export var sfxVolumeScale = 0.5


func _ready():
	sfx.volume_db = settings.GetSFXVolume(sfxVolumeScale)
	timer.connect("timeout", self, "next_state")
	next_state()

func next_state():
	if !state:
		animation.play("Start")
		sfx.play()
		state = true
	else:
		killZone.monitoring = false
		animation.play("End")
		sfx.stop()
		state = false

func _on_Animation_animation_finished():
	if state:
		animation.play("Loop")
		killZone.monitoring = true