extends AnimatedSprite

var time = 0.5

func _process(delta):
	if time > 0:
		self_modulate = Color(1, 1, 1, time)
		time -= delta
	else:
		queue_free()
