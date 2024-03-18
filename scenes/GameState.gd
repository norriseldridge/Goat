extends Node

onready var messageBroker = MessageBroker
onready var music = $Music
onready var settings = PlayerSettings

export var fadeSpeed = 50

export var mainMenuMusic = ""

var mainMenu
var gameController
var currentMusic = ""
var nextMusic = ""

func _ready():
	messageBroker.connect("selected_user_file", self, "_on_selected_user_file")
	messageBroker.connect("load_main_menu", self, "_on_load_main_menu")
	messageBroker.connect("play_music", self, "_on_play_music")
	messageBroker.connect("stop_music", self, "_on_stop_music")

	settings.Load()

	_on_load_main_menu()
	
func _process(delta):
	if currentMusic != nextMusic:
		if music.volume_db > -80:
			music.volume_db -= fadeSpeed * delta
		else:
			currentMusic = nextMusic
			if currentMusic != "":
				music.stream = load("res://music/" + nextMusic)
				music.play()
				music.volume_db = settings.GetMusicVolume()
			else:
				music.stop()
	else:
		music.volume_db = settings.GetMusicVolume()
	
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

func _on_stop_music():
	music.stop()