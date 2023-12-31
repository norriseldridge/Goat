extends KinematicBody2D

const AIR_FORCE = 100 # in code these are "ladders"
const GRAVITY = 300
const MAX_GRAVITY = 150
const FRICTION = 350

export var speed = 50
export var acceleration = 70
export var jumpForce = 50
export var maxJumpCount = 2
var velocity = Vector2.ZERO
var jumpCount = 0
var grounded = false
var ladderCount = 0

onready var animatedSprite = $AnimatedSprite
onready var messageBroker = MessageBroker
onready var jumpSfx = $JumpSFX
onready var globals = Globals

func _process(delta):
	if globals.paused:
		return
		
	var input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input_dir == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		animatedSprite.play("idle")
	else:
		velocity.x = move_toward(velocity.x, input_dir * speed, acceleration * delta)
		animatedSprite.play("run")
		if velocity.x > 0:
			animatedSprite.flip_h = false
		elif velocity.x < 0:
			animatedSprite.flip_h = true
	
	if !grounded:
		animatedSprite.play("falling")
		if ladderCount == 0:
			velocity.y += GRAVITY * delta
			if velocity.y > MAX_GRAVITY:
				velocity.y = MAX_GRAVITY
		else:
			velocity.y -= AIR_FORCE * delta
	
	if Input.is_action_just_pressed("jump") && jumpCount < maxJumpCount:
		velocity.y = -jumpForce
		jumpCount += 1
		jumpSfx.play()

func _physics_process(delta):
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)

func _on_Area2D_body_entered(body):
	grounded = true
	jumpCount = 0

func _on_Area2D_body_exited(body):
	grounded = false

func kill():
	messageBroker.emit_signal("player_died")
	queue_free()
