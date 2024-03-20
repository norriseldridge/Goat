extends Node2D

onready var messageBroker = MessageBroker
onready var settings = PlayerSettings
onready var movingPlatform = $MovingPlatforms/MovingPlatform6
onready var hidden = $Hidden
onready var hiddenCollision = $Hidden/KinematicBody2D/CollisionShape2D
onready var player = $Player
onready var camera = $Camera2D
onready var timer = $ReturnToPlayerTimer
onready var revealSfx = $AudioStreamPlayer2D


func _ready():
	movingPlatform.set_physics_process(false)
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	timer.connect("timeout", self, "enable_player")


func on_player_picked_up_coin():
	movingPlatform.set_physics_process(true)
	reveal()


func reveal():
	hidden.visible = false
	hiddenCollision.set_deferred("disabled", true)
	player.allowedToMove = false
	camera.follow_player = false
	camera.position = Vector2(96, -30)
	timer.start()
	
	revealSfx.volume_db = settings.GetSFXVolume()
	revealSfx.play()

func enable_player():
	player.allowedToMove = true
	camera.follow_player = true
	camera.position = player.position