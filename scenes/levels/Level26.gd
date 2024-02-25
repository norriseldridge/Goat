extends Node2D


onready var messageBroker = MessageBroker
onready var player = $Player
onready var chef = $Chef
onready var coin2 = $Coin2
onready var coin3 = $Coin3
onready var coin4 = $Coin4
onready var coin5 = $Coin5
onready var coin6 = $Coin6
onready var portal = $Portal
onready var levelLoadZone = $Portal/LevelLoadZone
onready var dialogue = $Dialogue
onready var timer = $Timer
onready var endingTimer = $EndingTimer

onready var stove18 = $Stove18
onready var stove19 = $Stove19

var nodeNames = ["Stove", "Stove2", "Stove3", "Stove4",
	"Stove5", "Stove6", "Stove7", "Stove8",
	"Stove9", "Stove10", "Stove11", "Stove12",
	"Stove13", "Stove14", "Stove15", "Stove16",
	"Stove17"]
var coinIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	chef.allowedToMove = false
	player.allowedToMove = false

	dialogue.Show()

	SetCoinActive(coin2, false)
	SetCoinActive(coin3, false)
	SetCoinActive(coin4, false)
	SetCoinActive(coin5, false)
	SetCoinActive(coin6, false)
	SetPortalActive(false)
	messageBroker.connect("dialogue_complete", self, "on_dialogue_complete")
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")


func on_dialogue_complete():
	chef.allowedToMove = true
	player.allowedToMove = true
	chef.sprite.play("Run")


func on_player_picked_up_coin():
	coinIndex += 1
	if coinIndex == 1:
		SetCoinActive(coin2, true)
		chef.phase = 1
		chef.showExclamation()
	if coinIndex == 2:
		SetCoinActive(coin3, true)
		chef.phase = 2
		chef.showExclamation()
	if coinIndex == 3:
		SetCoinActive(coin4, true)
		chef.showExclamation()
	if coinIndex == 4:
		SetCoinActive(coin5, true)
		$Chef/Timer.wait_time = 2
		chef.showExclamation()
		activateSideStoves()
	if coinIndex == 5:
		SetCoinActive(coin6, true)
		chef.showExclamation()
	if coinIndex == 6:
		chef.showFinalExclamation()
		endingTimer.start()
		deactivateSideStoves()
		messageBroker.emit_signal("stop_music")

func SetCoinActive(coin, state):
	coin.visible = state
	coin.monitoring = state

func SetPortalActive(state):
	portal.visible = state
	levelLoadZone.monitoring = state

func TurnOnStoves():
	for nodeName in nodeNames:
		print("Finding node " + nodeName + " ...")
		var node = get_tree().get_root().find_node(nodeName, true, false)
		node.next_state()

func _on_Timer_timeout():
	TurnOnStoves()

func activateSideStoves():
	stove18.timer.one_shot = false
	stove19.timer.one_shot = false
	stove18.timer.start(1)
	stove19.timer.start(1)

func deactivateSideStoves():
	stove18.timer.one_shot = true
	stove19.timer.one_shot = true
	stove18.timer.stop()
	stove19.timer.stop()


func _on_EndingTimer_timeout():
	TurnOnStoves()
	chef.kill()
	SetPortalActive(true)
	timer.start()
