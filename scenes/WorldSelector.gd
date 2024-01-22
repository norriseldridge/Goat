extends Node2D

onready var messageBroker = MessageBroker
onready var camera = $Camera2D
onready var levelUtility = LevelUtility
onready var levelSelect = $LevelSelect
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
	if levelSelect.visible:
		return

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
	levelSelect.Show(worldData[activeIndex], playerData)
