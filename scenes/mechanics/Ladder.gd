extends Area2D

var player = null

func _ready():
	$AnimatedSprite.frame = 0
	$AnimatedSprite2.frame = 0
	$AnimatedSprite3.frame = 0
	$AnimatedSprite.play()
	$AnimatedSprite2.play()
	$AnimatedSprite3.play()

func _on_Ladder_body_entered(body):
	player = body
	player.ladderCount = player.ladderCount + 1

func _on_Ladder_body_exited(_body):
	player.ladderCount = player.ladderCount - 1
	player = null
