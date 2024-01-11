extends Node

onready var messageBroker = MessageBroker
onready var music = $Music

export var fadeSpeed = 50

var mainMenuMusic = "Intro.mp3"

var mainMenu
var gameController
var currentMusic = ""
var nextMusic = ""

func _ready():
	messageBroker.connect("selected_user_file", self, "_on_selected_user_file")
	messageBroker.connect("load_main_menu", self, "_on_load_main_menu")
	messageBroker.connect("play_music", self, "_on_play_music")
	_on_load_main_menu()
	
func _process(delta):
	if currentMusic != nextMusic:
		if music.volume_db > -80:
			music.volume_db -= fadeSpeed * delta
		else:
			currentMusic = nextMusic
			music.stream = load("res://music/" + nextMusic)
			music.play()
			music.volume_db = 0
	
func _on_load_main_menu():
	if gameController != null:
		gameController.queue_free()
		
	if mainMenu != null:
		mainMenu.queue_free()
	mainMenu = load("res://scenes/ui/MainMenu.tscn").instance()
	add_child(mainMenu)
	
	_on_play_music(mainMenuMusic)

func _on_selected_user_file(userFile):
	remove_child(mainMenu)
	gameController = load("res://scenes/GameController.tscn").instance()
	gameController.selectedUserFile = userFile
	add_child(gameController)

func _on_play_music(song):
	if nextMusic != song:
		nextMusic = song
