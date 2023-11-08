extends Node

onready var messageBroker = MessageBroker
var gameOverScene = preload("res://scenes/ui/GameOver.tscn")
var levelTransitionScene = preload("res://scenes/ui/LevelTransition.tscn")

onready var levelUtility = LevelUtility
var current_level = null

onready var camera = $Camera2D

onready var hud = $Camera2D/CanvasLayer/HUD
onready var playerData = $PlayerData

onready var pickUpSfx = $PickUpSfx
onready var doorUnlockSfx = $DoorUnlockSfx
onready var playerDiedSfx = $PlayerDiedSfx
onready var enteredPortalSfx = $EnteredPortalSfx

func _ready():
	messageBroker.connect("player_died", self, "on_player_died")
	messageBroker.connect("player_picked_up_key", self, "on_player_picked_up_key")
	messageBroker.connect("player_entered_door_unlock", self, "on_player_entered_door_unlock")
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	
	messageBroker.connect("player_entered_portal", self, "on_player_entered_portal")
	messageBroker.connect("load_level", self, "on_load_level")
	
	playerData.Load()
	on_load_level(playerData.currentLevel)

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		# todo open menu
		playerData.Save()
		get_tree().quit()

func on_player_died():
	playerDiedSfx.play()
	var gameOver = gameOverScene.instance()
	gameOver.retryScene = playerData.currentLevel
	camera.add_child(gameOver)
	camera.shake(0.7)
	pass
	
func on_player_picked_up_key():
	playerData.keys += 1
	hud.set_keys(playerData.keys)
	pickUpSfx.play()
	
func on_player_entered_door_unlock(doorid):
	if playerData.keys > 0:
		playerData.keys -= 1
		hud.set_keys(playerData.keys)
		messageBroker.emit_signal("player_unlocked_door", doorid)
		doorUnlockSfx.play()

func on_player_picked_up_coin():
	playerData.coins += 1
	hud.set_score(playerData.coins)
	pickUpSfx.play()

func on_player_entered_portal(nextLevel):
	playerData.SaveLevelScore()
	
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	enteredPortalSfx.play()
	var transitionScene = levelTransitionScene.instance()
	transitionScene.nextLevel = nextLevel
	add_child(transitionScene)

func on_load_level(nextLevel):
	if current_level != null:
		current_level.queue_free()
	
	playerData.ResetState(nextLevel)
	hud.set_keys(playerData.keys)
	hud.set_score(playerData.coins)
	
	playerData.currentLevel = nextLevel
	var levelScene = levelUtility.GetScene(playerData.currentLevel)
	current_level = load(levelScene).instance()
	add_child(current_level)
