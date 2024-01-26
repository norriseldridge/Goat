extends Node2D

onready var sprite = $Sprite
onready var collision = $KinematicBody2D/CollisionShape2D

export(float) var max_delay = 2.5
onready var delay = 0
export var active = true

func _ready():
	set_active(active)

func _process(delta):
	delay += delta
	if delay >= max_delay:
		delay = 0
		active = !active
		set_active(active)

func set_active(is_active):
	sprite.frame = 21 if is_active else 20
	collision.set_deferred("disabled", !is_active)
