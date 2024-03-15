extends Node2D

export (String, MULTILINE) var nodeNames
var nodes = []

func _ready():
	for nodeName in nodeNames.rsplit("\n"):
		# print("Finding node " + nodeName + " ...")
		var node = get_tree().get_root().find_node(nodeName, true, false)
		if node != null:
			nodes.append(node)
	
	for node in nodes:
		node.set_process(false)
		node.set_physics_process(false)
		

func _on_Area2D_body_entered(_body):
	for node in nodes:
		node.set_process(true)
		node.set_physics_process(true)
	queue_free()
