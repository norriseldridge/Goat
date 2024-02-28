extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var sprite = $AnimatedSprite
onready var groundedCheckbox = $GroundedCheckBox
var velocity = Vector2.ZERO
var grounded = false


func kill():
	sprite.play("Burn")


func _process(delta):
	if !grounded:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY
	else:
		for body in groundedCheckbox.get_overlapping_bodies():
			print("body: " + body.name)


func _physics_process(_delta):
	grounded = groundedCheckbox.get_overlapping_bodies().size() > 0
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)
