extends Node2D


onready var messageBroker = MessageBroker
onready var player = $Player
onready var chef = $Chef
onready var coin2 = $Coin2
onready var coin3 = $Coin3
onready var portal = $Portal
onready var levelLoadZone = $Portal/LevelLoadZone
onready var dialogue = $Dialogue
onready var timer = $Timer

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
	if coinIndex == 2:
		SetCoinActive(coin3, true)
		chef.phase = 1
	if coinIndex == 3:
		TurnOnStoves()
		chef.kill()
		SetPortalActive(true)
		timer.start()

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
