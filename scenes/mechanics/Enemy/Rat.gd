extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var sprite = $AnimatedSprite
onready var leftDetector = $LeftDetector
onready var rightDetector = $RightDetector
onready var leftWallDetector = $LeftSideDetector
onready var rightWallDetector = $RightSideDetector
onready var groundDetector = $GroundDetector

export var speed = 30
var run_time = 2
var wait_time = 0.75
var current_time = 0.0

var facingRight = true
var velocity = Vector2.ZERO
var grounded = false
var running = true

func _process(delta):
	current_time += delta
	if running:
		sprite.play("default")
		if current_time > run_time:
			running = false
			current_time = 0
	else:
		sprite.play("idle")
		if current_time > wait_time:
			running = true
			current_time = 0

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
	
	if !running:
		velocity.x = 0

	grounded = groundDetector.get_overlapping_bodies().size() > 0
	if !grounded:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY


func _physics_process(_delta):
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)

