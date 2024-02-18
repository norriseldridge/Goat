extends Node2D

onready var knife = preload("res://scenes/mechanics/Knife.tscn")
onready var timer = $Timer
var pool = []
export var max_count = 5
export var shootLeft = true

func _ready():
	timer.connect("timeout", self, "spawn_knife")
	spawn_knife()

func spawn_knife():
	if pool.size() < max_count:
		var new_knife = knife.instance()
		new_knife.position = position
		new_knife.movement = Vector2.LEFT if shootLeft else Vector2.RIGHT
		get_parent().call_deferred("add_child", new_knife)
		pool.append(new_knife)
	else:
		pool[0].position = position
		pool.append(pool[0])
		pool.remove(0)
