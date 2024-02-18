extends Node2D

export var speed = 20
var moveTowardsBegin = false
onready var chef = $Chef
onready var sprite = $Chef/AnimatedSprite
onready var start = $Start
onready var end = $End

onready var meatball = preload("res://scenes/mechanics/Enemy/Meatball.tscn")
var meatballs = []

func _physics_process(delta):
	var movement = Vector2()
	if moveTowardsBegin:
		movement = chef.position.direction_to(start.position)
		if chef.position.distance_to(start.position) <= 1:
			moveTowardsBegin = false
	else:
		movement = chef.position.direction_to(end.position)
		if chef.position.distance_to(end.position) <= 1:
			moveTowardsBegin = true
	# platform.move_and_collide(movement * speed * delta)
	sprite.flip_h = movement.x < 0
	chef.position = chef.position + (movement * speed * delta)


func _on_Timer_timeout():
	if meatballs.size() < 5:
		var temp = meatball.instance()
		temp.position = position + chef.position - Vector2(0, 12)
		get_parent().add_child(temp)
		meatballs.append(temp)
	else:
		var temp = meatballs.pop_front()
		temp.reset()
		temp.position = position + chef.position - Vector2(0, 12)
		meatballs.append(temp)

