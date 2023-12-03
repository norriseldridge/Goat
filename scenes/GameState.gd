extends Node

onready var messageBroker = MessageBroker

var mainMenu
var gameController

func _ready():
	messageBroker.connect("selected_user_file", self, "_on_selected_user_file")
	mainMenu = load("res://scenes/ui/MainMenu.tscn").instance()
	add_child(mainMenu)

func _on_selected_user_file(userFile):
	remove_child(mainMenu)
	gameController = load("res://scenes/GameController.tscn").instance()
	gameController.selectedUserFile = userFile
	add_child(gameController)
