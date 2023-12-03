extends Area2D

var player = null

func _on_Ladder_body_entered(body):
	player = body
	player.ladderCount = player.ladderCount + 1

func _on_Ladder_body_exited(body):
	player.ladderCount = player.ladderCount - 1
	player = null
