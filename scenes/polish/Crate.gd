extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var settings = PlayerSettings

onready var sprite = $AnimatedSprite
onready var collider = $CollisionShape2D
onready var area = $Area2D
onready var groundDetector = $GroundDetector
onready var sfx = $AudioStreamPlayer2D

var player = null
var velocity = Vector2.ZERO
var grounded = false
var broken = false

func break_crate():
	broken = true

	sfx.volume_db = settings.GetSFXVolume()
	sfx.play()
	velocity.y = 0
	sprite.play()
	area.monitoring = false
	area.monitorable = false
	collider.set_deferred("disabled", true)

func _on_Area2D_body_entered(body:Node):
	player = body

func _on_Area2D_body_exited(_body:Node):
	player = null

func _process(delta):
	if broken:
		return

	if player != null:
		if player.is_dashing:
			break_crate()

	grounded = false
	for body in groundDetector.get_overlapping_bodies():
		if body != self:
			grounded = true
			break
	
	if !grounded:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY

func _physics_process(_delta):
	if broken:
		return
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)