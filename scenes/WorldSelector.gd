extends Node2D

onready var messageBroker = MessageBroker
onready var camera = $Camera2D
onready var levelUtility = LevelUtility
var playerData = null
var worldData = null

var levelNodes = []
var activeIndex = 0

func _ready():
	camera.current = true
	
	levelNodes = [
		$CastleEntrance,
		$CastleEntrance2,
		$CastleEntrance3,
		$CastleEntrance4,
		$CastleEntrance5,
		$CastleEntrance6,
		$CastleEntrance7
	]
	
	worldData = levelUtility.GetWorldData()
	for index in worldData.size():
		levelNodes[index].SetWorldData(worldData[index])
		
		if levelUtility.GetWorldUnlocked(worldData[index], playerData):
			activeIndex = index
	
	SetActive(activeIndex)

func SetActive(index):
	for i in levelNodes.size():
		levelNodes[i].visible = i == index
	
func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		ChangeIndex(1)
		
	if Input.is_action_just_pressed("ui_left"):
		ChangeIndex(-1)
		
	if Input.is_action_just_pressed("ui_accept"):
		SelectWorld()

func ChangeIndex(amount):
	var previousIndex = activeIndex
	activeIndex = activeIndex + amount
	if activeIndex < 0:
		activeIndex = 0
	
	if activeIndex >= levelNodes.size():
		activeIndex = levelNodes.size() - 1
	
	if !levelUtility.GetWorldUnlocked(worldData[activeIndex], playerData):
		activeIndex = previousIndex
	SetActive(activeIndex)

func SelectWorld():
	# either load the current level or the first level of this world
	var levels = worldData[activeIndex].levels
	messageBroker.emit_signal("play_music", worldData[activeIndex].music)
	if playerData.currentLevel in levels:
		messageBroker.emit_signal("load_level", playerData.currentLevel)
	else:
		messageBroker.emit_signal("load_level", levels[0])
