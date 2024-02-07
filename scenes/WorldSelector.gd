extends Node2D

onready var messageBroker = MessageBroker
onready var camera = $Camera2D
onready var levelUtility = LevelUtility
onready var levelSelect = $LevelSelect
var playerData = null
var worldData = null

var levelNodes = []
var activeIndex = 0
var worldPaths = []

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

	worldPaths = [
		$Castle/Castle_gate_bridge,
		$Castle/Castle_bridge_kitchen,
		$Castle/Castle_kitchen_dock,
		$Castle/Castle_dock_conservatory,
		$Castle/Castle_conservatory_tower,
		$Castle/Castle_tower_dungeon
	]
	
	var pathIndex = -1
	worldData = levelUtility.GetWorldData()
	for index in worldData.size():
		levelNodes[index].SetWorldData(worldData[index])
		
		var unlocked = levelUtility.GetWorldUnlocked(worldData[index], playerData)
		if unlocked:
			activeIndex = index
	
		pathIndex = index - 1
		if pathIndex >= 0:
			worldPaths[pathIndex].visible = unlocked
	
	SetActive(activeIndex)

func SetActive(index):
	for i in levelNodes.size():
		levelNodes[i].visible = i == index
	
func _process(_delta):
	if levelSelect.visible:
		if Input.is_action_just_pressed("escape"):
			levelSelect.visible = false
		return

	if Input.is_action_just_pressed("escape"):
		messageBroker.emit_signal("load_main_menu")

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
