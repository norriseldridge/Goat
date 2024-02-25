extends Node2D


onready var messageBroker = MessageBroker
onready var chef = $BackgroundChef
onready var chefSprite = $BackgroundChef/Chef/AnimatedSprite
onready var chefExclamation = $BackgroundChef/Chef/ExclamationPoint
onready var chefMeatballTimer = $BackgroundChef/Timer
onready var lookTimer = $ChefLookTimer
onready var runTimer = $ChefRunTimer
onready var meatball = $GiantMeatball
onready var portal = $Portal
onready var levelLoadZone = $Portal/LevelLoadZone
var moveMeatball = false
var isDone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	lookTimer.connect("timeout", self, "on_lookTimer")
	runTimer.connect("timeout", self, "on_runTimer")
	SetPortalActive(false)


func _process(delta):
	if moveMeatball && !isDone:
		if meatball.position.x > -24:
			meatball.rotate(-2 * delta)
			meatball.position += Vector2(-41 * delta, 0)
		else:
			isDone = true
			messageBroker.emit_signal("camera_shake")
			SetPortalActive(true)


func on_player_picked_up_coin():
	chefMeatballTimer.stop()
	chef.set_physics_process(false)
	chefSprite.stop()
	chefSprite.frame = 0
	chefSprite.flip_h = false
	lookTimer.start()


func on_lookTimer():
	chefExclamation.visible = true
	runTimer.start()


func on_runTimer():
	chefExclamation.visible = false
	chef.speed = 40
	chef.set_physics_process(true)
	chefSprite.play()
	$BackgroundChef/Start.position.x = -12
	$BackgroundChef/End.position.x = -12
	moveMeatball = true


func SetPortalActive(state):
	portal.visible = state
	levelLoadZone.monitoring = state
