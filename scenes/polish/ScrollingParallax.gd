extends ParallaxLayer

export var speed = 1.0

func _process(delta):
	motion_offset += Vector2.LEFT * speed * delta
