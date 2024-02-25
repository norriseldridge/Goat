extends Node2D

export (Vector2) var force = Vector2(-5, 0)
var bodies = []


func _physics_process(delta):
	for body in bodies:
		body.position += force * delta


func _on_Area2D_body_entered(body:Node):
	bodies.append(body)


func _on_Area2D_body_exited(body:Node):
	var index = bodies.find(body)
	if index >= 0:
		bodies.remove(index)

