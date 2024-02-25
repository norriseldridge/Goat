extends KinematicBody2D

const GRAVITY = 300
const MAX_GRAVITY = 150

onready var sprite = $AnimatedSprite

export var speed = 30

export var facingRight = true
var velocity = Vector2.ZERO
var grounded = false
var dead = false
var allowedToMove = true


var pool = []
export var max_count = 5

onready var left_knife = preload("res://scenes/mechanics/Knife.tscn")
onready var right_knife = preload("res://scenes/mechanics/Knife_Right.tscn")
var phase = 0
var shotIndex = 0

onready var meatball = preload("res://scenes/mechanics/Enemy/Meatball.tscn")
var meatballs = []

onready var exclamationPoint = $ExclamationPoint
onready var hideExclamationTimer = $HideExclamationTimer
var inFinalAnimation = false

func _process(delta):
	if dead:
		return

	if !inFinalAnimation:
		sprite.flip_h = !facingRight

	if !allowedToMove:
		return

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
	if dead or !allowedToMove:
		return

	if phase > 0:
		# shoot a knife
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

	if phase > 1:
		# also shot a meatball
		if meatballs.size() < 5:
			var temp = meatball.instance()
			temp.position = position - Vector2(0, 12)
			get_parent().add_child(temp)
			meatballs.append(temp)
		else:
			var temp = meatballs.pop_front()
			temp.reset()
			temp.position = position - Vector2(0, 12)
			meatballs.append(temp)


func kill():
	dead = true
	$KillZone.set_deferred("monitorable", false)
	$KillZone.set_deferred("monitoring", false)
	velocity = Vector2.ZERO
	sprite.play("Burn")
	$CollisionShape2D.set_deferred("disabled", true)
	exclamationPoint.visible = false

func showExclamation():
	hideExclamationTimer.start()
	exclamationPoint.visible = true
	allowedToMove = false
	velocity.x = 0


func _on_HideExclamationTimer_timeout():
	exclamationPoint.visible = false
	allowedToMove = true


func showFinalExclamation():
	exclamationPoint.visible = true
	allowedToMove = false
	velocity.x = 0
	inFinalAnimation = true
	sprite.play("Idle")

func _on_FinalAnimationTimer_timeout():
	if inFinalAnimation && !dead:
		sprite.flip_h = !sprite.flip_h
