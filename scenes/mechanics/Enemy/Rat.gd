extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var sprite = $AnimatedSprite

export var speed = 30

var facingRight = true
var velocity = Vector2.ZERO
var grounded = false


func _process(delta):
	sprite.flip_h = !facingRight

	if facingRight:
		velocity.x = speed
	else:
		velocity.x = -speed

	if !grounded:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY


func _physics_process(_delta):
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)


func _on_LeftSideDetector_body_entered(_body:Node):
	facingRight = true


func _on_RightSideDetector_body_entered(_body:Node):
	facingRight = false


func _on_GroundDetector_body_exited(_body:Node):
	grounded = false


func _on_GroundDetector_body_entered(_body:Node):
	grounded = true
