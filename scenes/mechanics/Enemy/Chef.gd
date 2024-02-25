extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var sprite = $AnimatedSprite

export var speed = 30

export var facingRight = true
var velocity = Vector2.ZERO
var grounded = false
var dead = false


var pool = []
export var max_count = 5

onready var left_knife = preload("res://scenes/mechanics/Knife.tscn")
onready var right_knife = preload("res://scenes/mechanics/Knife_Right.tscn")
var phase = 0
var shotIndex = 0

func _process(delta):
	if dead:
		return

	sprite.flip_h = !facingRight

	if facingRight:
		velocity.x = speed
	else:
		velocity.x = -speed

	if !grounded:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_GRAVITY:
			velocity.y = MAX_GRAVITY


func _physics_process(_delta):
	# this is to get moving platforms working... don't ask me how this works
	var snap = Vector2.DOWN if grounded else Vector2.ZERO
	move_and_slide_with_snap(velocity, snap, Vector2.UP)


func _on_LeftSideDetector_body_entered(_body:Node):
	facingRight = true


func _on_RightSideDetector_body_entered(_body:Node):
	facingRight = false


func _on_GroundDetector_body_exited(_body:Node):
	grounded = false


func _on_GroundDetector_body_entered(_body:Node):
	grounded = true


func _on_Timer_timeout():
	if dead:
		return
		
	shotIndex += 1
	if pool.size() >= max_count:
		var temp = pool.pop_front()
		get_parent().call_deferred("remove_child", temp)

	var knife = right_knife if facingRight else left_knife
	var new_knife = knife.instance()
	new_knife.position = position

	if facingRight:
		new_knife.position += Vector2(24, -12 if phase == 0 else -30 if (shotIndex % 2 == 0) else -12)
	else:
		new_knife.position += Vector2(-36, -12 if phase == 0 else -30 if (shotIndex % 2 == 0) else -12)

	new_knife.movement = Vector2.RIGHT if facingRight else Vector2.LEFT
	get_parent().call_deferred("add_child", new_knife)
	pool.append(new_knife)


func kill():
	dead = true
	velocity = Vector2.ZERO
	sprite.play("Burn")