extends Camera2D

onready var messageBroker = MessageBroker

var player = null
onready var camera_offset = Vector2.ZERO
var follow_player = true

var elapsedTime = 0
var duration = 0
var amount = 1
var speed = 35

func _ready():
	messageBroker.connect("camera_shake", self, "on_camera_shake")
	player = get_tree().get_root().find_node("Player", true, false)

func _process(delta):
	if elapsedTime < duration:
		elapsedTime += delta
		offset = amount * Vector2(sin(elapsedTime * speed), 0) #cos(elapsedTime * speed))
	else:
		offset = Vector2.ZERO

	if !is_instance_valid(player):
		return

	if !follow_player:
		return

	if player.input_dir > 0:
		if camera_offset.x < 36:
			camera_offset += Vector2.RIGHT * 10 * delta
	
	if player.input_dir < 0:
		if camera_offset.x > -36:
			camera_offset += Vector2.LEFT * 10 * delta
	position = player.position + camera_offset

func shake(new_duration):
	self.duration = new_duration
	elapsedTime = 0

func on_camera_shake():
	shake(0.7)