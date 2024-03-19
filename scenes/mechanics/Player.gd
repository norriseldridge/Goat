extends KinematicBody2D

const AIR_FORCE = 120 # in code these are "ladders"
const MAX_AIR_FORCE = 120
const MAX_AIR_GRAVITY = 80
const GRAVITY = 300
const MAX_GRAVITY = 150
const FRICTION = 400
const IN_AIR_FRICTION_MOD = 0.7
const IN_AIR_ACCEL_MOD = 0.8
const SLIPPERY_SURFACE_MOD = 0.01
const SLIPPERY_SURFACE_ACCEL_MOD = 0.3

export var speed = 50
export var dash_burst = 60
export var dash_speed = 75
export var acceleration = 70
export var jumpForce = 50
export var maxJumpCount = 2
var velocity = Vector2.ZERO
var input_dir = 0.0
var jumpCount = 0
var grounded = false
var ladderCount = 0
var slipperyFloorCount = 0
var is_dead = false
var allowedToMove = true
var dashDuration = 0.2
var dashDurationTime = 0.0
var dashCooldown = 0.25
var dashCooldownTime = 0.0
var is_dashing = false
var can_dash = true

onready var animatedSprite = $AnimatedSprite
onready var deathSprite = $DeathAnimation
onready var groundedCheckbox = $Area2D
onready var messageBroker = MessageBroker
onready var settings = PlayerSettings
onready var jumpSfx = $JumpSFX
onready var runSfx = $RunSFX
onready var dashSfx = $DashSFX
onready var globals = Globals

var rng = RandomNumberGenerator.new()

var dustKickSource = preload("res://scenes/polish/DustKick.tscn")
var playerTrailEffect = preload("res://scenes/polish/PlayerTrailEffect.tscn")

func _ready():
	rng.randomize()
	jumpSfx.volume_db = settings.GetSFXVolume()
	runSfx.volume_db = settings.GetSFXVolume(6)
	dashSfx.volume_db = settings.GetSFXVolume()

func _process(delta):
	if globals.paused or is_dead:
		return

	handle_movement(delta)
	handle_gravity(delta)
	handle_jump()
	handle_dash()
	if is_dashing:
		animatedSprite.play("dash")
	
func handle_movement(delta):
	var frictionMod = 1.0
	var accelMod = 1.0
	if !grounded:
		frictionMod = IN_AIR_FRICTION_MOD
		accelMod = IN_AIR_ACCEL_MOD
	elif slipperyFloorCount > 0:
		frictionMod = SLIPPERY_SURFACE_MOD
		accelMod = SLIPPERY_SURFACE_ACCEL_MOD
		
	input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if !allowedToMove:
		input_dir = 0
		
	if is_dashing:
		dashDurationTime += delta
		input_dir = -1 if animatedSprite.flip_h else 1

		# spawn trail effects
		var temp = playerTrailEffect.instance()
		temp.position = position - (Vector2.RIGHT * 2 * input_dir)
		temp.flip_h = animatedSprite.flip_h
		temp.animation = animatedSprite.animation
		temp.frame = animatedSprite.frame
		get_parent().add_child(temp)

		if dashDurationTime >= dashDuration:
			is_dashing = false
			if velocity.x > speed:
				velocity.x = speed
			if velocity.x < -speed:
				velocity.x = -speed
	else:
		if !can_dash:
			dashCooldownTime += delta
			if dashCooldownTime >= dashCooldown:
				can_dash = true
				dashCooldownTime = 0.0

	if input_dir == 0:
		velocity.x = move_toward(velocity.x, 0, frictionMod * FRICTION * delta)
		animatedSprite.play("idle")
	else:
		var target_speed = dash_speed if is_dashing else speed
		velocity.x = move_toward(velocity.x, input_dir * target_speed, accelMod * acceleration * delta)
		animatedSprite.play("run")
		if input_dir > 0:
			animatedSprite.flip_h = false
		elif input_dir < 0:
			animatedSprite.flip_h = true

func handle_gravity(delta):
	if is_dashing:
		return

	if !grounded:
		animatedSprite.play("falling")
		if ladderCount == 0:
			velocity.y += GRAVITY * delta
			if velocity.y > MAX_GRAVITY:
				velocity.y = MAX_GRAVITY
		else:
			jumpCount = 0
			if velocity.y > -MAX_AIR_FORCE:
				velocity.y -= AIR_FORCE * delta

			if velocity.y > MAX_AIR_GRAVITY:
				velocity.y -= 1.25 * AIR_FORCE * delta

func handle_jump():
	if Input.is_action_just_pressed("jump") && jumpCount < maxJumpCount:
		velocity.y = -jumpForce
		jumpCount += 1
		jumpSfx.play()

func handle_dash():
	if !allowedToMove:
		return

	if Input.is_action_just_pressed("dash"):
		if !is_dashing && can_dash:
			dashSfx.play()
			dashDurationTime = 0.0
			is_dashing = true
			can_dash = false
			
			if !animatedSprite.flip_h:
				velocity.x += dash_burst
			else:
				velocity.x += -dash_burst
			velocity.y = 0

func _physics_process(_delta):
	if is_dead:
		return

	grounded = groundedCheckbox.get_overlapping_bodies().size() > 0

	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)

func _on_Area2D_body_entered(_body):
	if velocity.y >= 0:
		jumpCount = 0
		velocity.y = 5

func _on_Area2D_body_exited(_body):
	pass

func kill():
	deathSprite.visible = true
	deathSprite.play()
	animatedSprite.visible = false
	is_dead = true
	messageBroker.emit_signal("player_died")

func _on_DeathAnimation_animation_finished():
	messageBroker.emit_signal("show_gameover_screen")
	queue_free()

func _on_DustTimer_timeout():
	if grounded && velocity.x != 0 && input_dir != 0:
		spawn_dust()

		runSfx.pitch_scale = rng.randf_range(0.95, 1)
		runSfx.play()

func spawn_dust():
	if is_dead:
		return
		
	var kick = dustKickSource.instance()
	kick.position = position
	get_parent().add_child(kick)
