extends Camera2D

var elapsedTime = 0
var duration = 0
var amount = 0.5
var speed = 35

func shake(duration):
	self.duration = duration
	elapsedTime = 0

func _process(delta):
	if elapsedTime < duration:
		elapsedTime += delta
		position = amount * Vector2(sin(elapsedTime * speed), 0) #cos(elapsedTime * speed))
	else:
		position = Vector2.ZERO
