extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var leftDetector = $LeftDetector
onready var rightDetector = $RightDetector
onready var leftWallDetector = $LeftWallDetector
onready var rightWallDetector = $RightWallDetector
onready var groundDetector = $GroundDetector
onready var sprite = $AnimatedSprite
export var facingRight = true
export var max_speed = 5.0

var velocity = Vector2.ZERO
var grounded = false
var speed = 1.0

func _process(delta):
	speed = 1.0 if sprite.frame == 2 else max_speed

	if facingRight:
		if rightDetector.get_overlapping_bodies().size() == 0 || rightWallDetector.get_overlapping_bodies().size() > 0:
			facingRight = false
		else:
			sprite.flip_h = false
			velocity = Vector2.RIGHT * speed
	else:
		if leftDetector.get_overlapping_bodies().size() == 0 || leftWallDetector.get_overlapping_bodies().size() > 0:
			facingRight = true
		else:
			sprite.flip_h = true
			velocity = Vector2.LEFT * speed
	
	grounded = groundDetector.get_overlapping_bodies().size() > 0
	if !grounded:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY

func _physics_process(_delta):
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)
