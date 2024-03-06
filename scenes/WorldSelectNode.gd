extends BaseButton

onready var messageBroker = MessageBroker
onready var worldLabel = $Label
onready var flashing = $AnimatedSprite
var worldData
var index = 0

func _ready():
	self.connect("mouse_entered", self, "_on_WorldSelectNode_mouse_entered")
	self.connect("pressed", self, "_on_WorldSelectNode_pressed")

func SetWorldData(data):
	worldData = data
	worldLabel.text = worldData.name

func SetActiveState(state: bool):
	flashing.visible = state
	worldLabel.visible = state

func _on_WorldSelectNode_mouse_entered():
	messageBroker.emit_signal("change_world_select_index", index)

func _on_WorldSelectNode_pressed():
	messageBroker.emit_signal("world_select_clicked")