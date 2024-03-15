extends Camera2D

var player = null
onready var camera_offset = Vector2.ZERO
var follow_player = true

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)

func _process(delta):
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
