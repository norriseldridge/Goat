extends Node

onready var messageBroker = MessageBroker
onready var globals = Globals
var gameOverScene = preload("res://scenes/ui/GameOver.tscn")
var pauseMenuScene = preload("res://scenes/ui/PauseMenu.tscn")
var worldSelectorScene = preload("res://scenes/WorldSelector.tscn")
var levelTransitionScene = preload("res://scenes/ui/LevelTransition.tscn")

onready var levelUtility = LevelUtility
var current_level = null
var worldSelector = null

onready var camera = $Camera2D
onready var hud = $Camera2D/CanvasLayer/HUD

onready var playerData = $PlayerData
var selectedUserFile = null
var keys = 0

onready var pickUpSfx = $PickUpSfx
onready var doorUnlockSfx = $DoorUnlockSfx
onready var playerDiedSfx = $PlayerDiedSfx
onready var enteredPortalSfx = $EnteredPortalSfx

var pause = null

func _ready():
	messageBroker.connect("player_died", self, "on_player_died")
	messageBroker.connect("player_picked_up_key", self, "on_player_picked_up_key")
	messageBroker.connect("player_entered_door_unlock", self, "on_player_entered_door_unlock")
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	messageBroker.connect("player_picked_up_food", self, "on_player_picked_up_food")
	
	messageBroker.connect("player_entered_portal", self, "on_player_entered_portal")
	messageBroker.connect("load_level", self, "on_load_level")
	
	if selectedUserFile != null:
		playerData.playerFileName = selectedUserFile
	playerData.Load()
	
	ShowWorldSelect()

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if !globals.paused:
			pause = pauseMenuScene.instance()
			pause.retryScene = playerData.currentLevel
			camera.add_child(pause)
			globals.paused = true
		else:
			pause.queue_free()
			pause = null
			globals.paused = false

func ShowWorldSelect():
	worldSelector = worldSelectorScene.instance()
	worldSelector.playerData = playerData
	add_child(worldSelector)
	hud.visible = false
	
func HideWorldSelect():
	if worldSelector != null:
		worldSelector.camera.current = false
		worldSelector.queue_free()
		worldSelector = null
	
	camera.current = true
	hud.visible = true

func on_player_died():
	playerDiedSfx.play()
	var gameOver = gameOverScene.instance()
	gameOver.retryScene = playerData.currentLevel
	camera.add_child(gameOver)
	camera.shake(0.7)
	
func on_player_picked_up_key():
	keys += 1
	hud.set_keys(keys)
	pickUpSfx.play()
	
func on_player_entered_door_unlock(doorid):
	if keys > 0:
		keys -= 1
		hud.set_keys(keys)
		messageBroker.emit_signal("player_unlocked_door", doorid)
		doorUnlockSfx.play()

func on_player_picked_up_coin():
	pickUpSfx.play()
	
func on_player_picked_up_food():
	pickUpSfx.play()

func on_player_entered_portal():
	playerData.MarkLevelCompleted()
	
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	enteredPortalSfx.play()
	var nextLevelId = levelUtility.GetNextLevel(playerData.currentLevel)
	var transitionScene = levelTransitionScene.instance()
	transitionScene.nextLevel = nextLevelId
	add_child(transitionScene)

func on_load_level(nextLevel):
	HideWorldSelect()
	
	if current_level != null:
		current_level.queue_free()
	
	keys = 0
	hud.set_keys(keys)
	
	if nextLevel == "-1":
		ShowWorldSelect()
		return
	
	globals.paused = false
	pause = null
	
	playerData.currentLevel = nextLevel
	var levelScene = levelUtility.GetScene(playerData.currentLevel)
	current_level = load(levelScene).instance()
	add_child(current_level)
