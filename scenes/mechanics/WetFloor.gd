extends Area2D

var player = null

func _on_WetFloor_body_entered(body:Node):
	player = body
	player.slipperyFloorCount = player.slipperyFloorCount + 1


func _on_WetFloor_body_exited(_body:Node):
	player.slipperyFloorCount = player.slipperyFloorCount - 1
	player = null