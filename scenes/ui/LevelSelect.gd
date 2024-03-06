extends CanvasLayer

onready var levelList = $Backing/Fill/ScrollContainer/LevelList
onready var levelUtility = LevelUtility
var levelSelectItem = preload("res://scenes/ui/LevelSelectItem.tscn")
onready var backButton = $Backing/Fill/BackButton

func _ready():
	$Backing.mouse_filter = Control.MOUSE_FILTER_IGNORE


func Show(worldData, playerData):
	$Backing.mouse_filter = Control.MOUSE_FILTER_STOP
	for child in levelList.get_children():
		levelList.remove_child(child)
		child.queue_free()

	var first = null
	for id in worldData.levels:
		var levelData = levelUtility.GetLevelData(id)
		var item = levelSelectItem.instance()
		item.levelId = id
		item.levelMusic = worldData.music
		item.levelName = levelData.name
		item.completed = playerData.completedLevels.has(id)

		if item.completed:
			item.highScore = playerData.levelHighScores[id]
			item.fastestTime = playerData.levelFastestTimes[id]
			
		if id == playerData.lastUnlockedLevel or id == playerData.currentLevel:
			item.current = true

		if first == null:
			first = item
		levelList.add_child(item)
		item.focus_neighbour_left = item.get_path_to(backButton)
		
		item.connect("mouse_entered", self, "_on_mouse_enter", [item])
	
	if levelUtility.GetWorldComplete(worldData, playerData):
		if first != null:
			first.grab_focus()

	visible = true


func _on_BackButton_pressed():
	visible = false
	$Backing.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_enter(button):
	button.grab_focus()
