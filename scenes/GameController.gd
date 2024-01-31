extends Node

onready var messageBroker = MessageBroker
onready var settings = PlayerSettings
onready var globals = Globals

var worldSelectorScene = preload("res://scenes/WorldSelector.tscn")
var levelTransitionScene = preload("res://scenes/ui/LevelTransition.tscn")

onready var levelUtility = LevelUtility
var current_level = null
var worldSelector = null

onready var camera = $Camera2D
onready var hud = $Camera2D/CanvasLayer/HUD
onready var gameOverDisplay = $GameOver
onready var pauseDisplay = $PauseMenu

onready var playerData = $PlayerData
var selectedUserFile = null
var keys = 0
var levelScore = 0
var levelTimeSeconds = 0.0

onready var pickUpSfx = $PickUpSfx
onready var doorUnlockSfx = $DoorUnlockSfx
onready var playerDiedSfx = $PlayerDiedSfx
onready var enteredPortalSfx = $EnteredPortalSfx

onready var levelNameLabel = $Camera2D/CanvasLayer/LevelStart/LevelName
onready var levelStartDisplay = $Camera2D/CanvasLayer/LevelStart

export var worldSelectMusic = ""

func _ready():
	messageBroker.connect("player_died", self, "on_player_died")
	messageBroker.connect("show_gameover_screen", self, "on_show_gameover_screen")
	messageBroker.connect("player_picked_up_key", self, "on_player_picked_up_key")
	messageBroker.connect("player_entered_door_unlock", self, "on_player_entered_door_unlock")
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	messageBroker.connect("player_picked_up_gem", self, "on_player_picked_up_gem")
	messageBroker.connect("player_picked_up_food", self, "on_player_picked_up_food")
	
	messageBroker.connect("player_entered_portal", self, "on_player_entered_portal")
	messageBroker.connect("load_level", self, "on_load_level")

	pickUpSfx.volume_db = settings.GetSFXVolume()
	doorUnlockSfx.volume_db = settings.GetSFXVolume()
	playerDiedSfx.volume_db = settings.GetSFXVolume()
	enteredPortalSfx.volume_db = settings.GetMusicVolume()
	
	gameOverDisplay.Hide()
	pauseDisplay.Hide()
	levelStartDisplay.visible = false
	
	if selectedUserFile != null:
		playerData.playerFileName = selectedUserFile
	playerData.Load()
	
	ShowWorldSelect()

func _exit_tree():
	playerData.Save()

func _process(delta):
	playerData.totalSecondsPlayed += delta

	if worldSelector != null:
		gameOverDisplay.Hide()
		pauseDisplay.Hide()
		if Input.is_action_just_pressed("escape"):
			messageBroker.emit_signal("load_main_menu")
		return

	if !globals.paused:
		levelTimeSeconds += delta
		hud.set_time(levelTimeSeconds)

	if levelStartDisplay.visible && levelTimeSeconds > 1.5:
		levelStartDisplay.visible = false
		
	if Input.is_action_just_pressed("escape"):
		if gameOverDisplay.visible:
			return

		if !globals.paused:
			pauseDisplay.retryScene = playerData.currentLevel
			pauseDisplay.Show()
			globals.paused = true
			get_tree().paused = true
		else:
			pauseDisplay.Hide()
			globals.paused = false
			get_tree().paused = false

func ShowWorldSelect():
	worldSelector = worldSelectorScene.instance()
	worldSelector.playerData = playerData
	add_child(worldSelector)
	hud.visible = false
	levelStartDisplay.visible = false
	messageBroker.emit_signal("play_music", worldSelectMusic)
	
func HideWorldSelect():
	if worldSelector != null:
		worldSelector.camera.current = false
		worldSelector.queue_free()
		worldSelector = null
	
	camera.current = true
	hud.visible = true

func on_player_died():
	playerDiedSfx.play()
	playerData.totalDeaths += 1
	playerData.Save()
	camera.shake(0.7)

func on_show_gameover_screen():
	globals.paused = false
	get_tree().paused = false
	pauseDisplay.Hide()

	gameOverDisplay.retryScene = playerData.currentLevel
	gameOverDisplay.Show()
	
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
	
func on_player_picked_up_gem():
	levelScore += 1
	hud.set_score(levelScore)
	pickUpSfx.play()
	
func on_player_picked_up_food():
	pickUpSfx.play()

func on_player_entered_portal():
	playerData.MarkLevelCompleted(levelScore, levelTimeSeconds)
	playerData.Save()
	
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	enteredPortalSfx.play()
	var nextLevelId = levelUtility.GetNextLevel(playerData.currentLevel)
	var transitionScene = levelTransitionScene.instance()
	transitionScene.nextLevel = nextLevelId
	add_child(transitionScene)

func on_load_level(nextLevel, retry = false):
	globals.paused = false
	get_tree().paused = false

	HideWorldSelect()
	
	if current_level != null:
		current_level.free()
		current_level = null
	
	keys = 0
	hud.set_keys(keys)

	levelScore = 0
	hud.set_score(levelScore)
	
	if nextLevel == "-1":
		UnlockNextWorldLevel()
		ShowWorldSelect()
		return
	
	gameOverDisplay.Hide()
	pauseDisplay.Hide()
	
	playerData.currentLevel = nextLevel
	if !playerData.completedLevels.has(nextLevel):
		playerData.lastUnlockedLevel = nextLevel

	playerData.Save()

	var levelData = levelUtility.GetLevelData(playerData.currentLevel)
	levelNameLabel.text = levelData.name
	var levelScene = levelData.scene
	current_level = load(levelScene).instance()
	add_child(current_level)
	levelTimeSeconds = 0
	levelStartDisplay.visible = !retry

func UnlockNextWorldLevel():
	var worldData = levelUtility.GetWorldData()
	for index in worldData.size():
		if levelUtility.GetWorldUnlocked(worldData[index], playerData):
			if worldData[index].levels.size() > 0:
				var firstLevelId = worldData[index].levels[0]
				if !playerData.completedLevels.has(firstLevelId):
					playerData.lastUnlockedLevel = firstLevelId
					playerData.Save()
					return
