extends Sprite

export var fallSpeedMin = 12
export var fallSpeedMax = 25
export var driftSpeedMin = 1
export var driftSpeedMax = 3
export var driftAmountMin = 2
export var driftAmountMax = 10
var fallSpeed = 10.0
var driftSpeed = 2
var driftAmount = 2
var positionX = 0.0
var offsetX = 0.0
var screenEdge = 0

func _ready():
	positionX = position.x
	screenEdge = get_viewport_rect().size.y
	reset()
	position.y = rand_range(-12, 188)

func _physics_process(delta):
	offsetX += driftSpeed * delta
	position.x = positionX + (driftAmount * sin(offsetX))
	position.y += fallSpeed * delta

	if position.y > screenEdge:
		reset()

func reset():
	position.y = rand_range(-6, -144)
	fallSpeed = rand_range(fallSpeedMin, fallSpeedMax)
	driftSpeed = rand_range(driftSpeedMin, driftSpeedMax)
	driftAmount = rand_range(driftAmountMin, driftAmountMax)