extends Sprite

const GRAVITY = 300
const MAX_GRAVITY = 150

export var shootForce = 200
export var shakeSpeed = 30
export var shakeAmount = 2
export (float) var initialDelay = 0.0

onready var lid = $KinematicBody2D
onready var sprite = $KinematicBody2D/PotLid
onready var timer = $Timer
onready var delayTimer = $InitialDelay
var velocity = Vector2.ZERO
var initalY = 0
var angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "on_timer")
	initalY = lid.position.y

	if initialDelay > 0:
		delayTimer.connect("timeout", self, "start_timer")
		delayTimer.wait_time = initialDelay
		delayTimer.start()
	else:
		timer.start()

func start_timer():
	timer.start()

func on_timer():
	sprite.rotation_degrees = 0
	velocity.y = -shootForce

func _process(delta):
	if lid.position.y > initalY:
		lid.position.y = initalY
		
		angle += delta * shakeSpeed
		sprite.rotation_degrees = sin(angle) * shakeAmount
	else:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY

func _physics_process(delta):
	lid.position += velocity * delta