extends Node2D


onready var messageBroker = MessageBroker
onready var settings = PlayerSettings

onready var goatDialogue = $GoatDialogue
onready var goatDialogue2 = $GoatDialogue2
onready var knightDialogue = $KnightDialogue
onready var player = $Player
onready var knight = $Knight
onready var knightTimer = $KnightTimer
onready var arrowTimer = $ArrowTimer
onready var ballista = $Ballista
onready var ballistaArrow = $Arrow
onready var movingPlatform = $MovingPlatform
onready var movingPlatform2 = $MovingPlatform2
onready var movingPlatform3 = $MovingPlatform3
onready var cage = $Cage/CollisionShape2D
onready var cageAnimation = $Cage/AnimatedSprite
onready var goatFriend = $GoatFriend
onready var cageBreakArea = $CageBreakArea
onready var knightLandSFX = $KnightLandSFX
onready var arrowSFX = $ArrowSFX
onready var impactSFX = $ImpactSFX
onready var cageSFX = $CageSFX
onready var windSFX = $WindSFX

var shownGoatDialogue = false
var shownGoatDialogue2 = false
var shownKnightDialogue = false
var dropKnightIn = false
var ballistaFired = false
var speed = 200.0
var won = false
var cageBroken = false

var dustKickSource = preload("res://scenes/polish/DustKick.tscn")
var arrowSource = preload("res://scenes/mechanics/Enemy/Arrow.tscn")
var arrows = []

func _ready():
	movingPlatform.set_physics_process(false)
	movingPlatform2.set_physics_process(false)
	movingPlatform3.set_physics_process(false)

	windSFX.volume_db = settings.GetSFXVolume(0.5)
	windSFX.play()

	messageBroker.connect("dialogue_complete", self, "on_dialogue_complete")
	messageBroker.connect("player_picked_up_coin", self, "on_player_picked_up_coin")
	arrowTimer.connect("timeout", self, "on_arrow_timer")
	knightTimer.connect("timeout", self, "on_knight_timer")

func _process(delta):
	if dropKnightIn:
		if knight.position.y < 72:
			knight.position.y += speed * delta
		else:
			if !shownKnightDialogue:
				knight.position.y = 72

				knightLandSFX.volume_db = settings.GetSFXVolume(2)
				knightLandSFX.play()

				var kick = dustKickSource.instance()
				kick.position = knight.position + (Vector2.UP * 6)
				add_child(kick)

				shownKnightDialogue = true
				knightDialogue.Show()

	if ballistaFired:
		ballistaArrow.position.x -= 200 * delta
		if ballistaArrow.position.x < 24:
			knight.position.x -= 200 * delta
			
			if ballistaArrow.position.x < -24:
				if !won:
					won = true
					impactSFX.volume_db = settings.GetSFXVolume()
					impactSFX.play()
					messageBroker.emit_signal("camera_shake")
					messageBroker.emit_signal("stop_music")
					
	if won:
		if cageBreakArea.get_overlapping_bodies().size() > 0:
			if player.is_dashing:
				if !cageBroken:
					cageBroken = true
					messageBroker.emit_signal("camera_shake")
					cageAnimation.play()
					cageSFX.play()
					goatFriend.z_index = 1
					cage.set_deferred("disabled", true)

func _on_GoatDialogueTrigger_body_entered(_body:Node):
	if !shownGoatDialogue:
		goatDialogue.Show()
		shownGoatDialogue = true
		player.allowedToMove = false

func on_dialogue_complete():
	player.allowedToMove = true

	if !dropKnightIn:
		knightTimer.start()
	else:
		messageBroker.emit_signal("play_music", "Goat-gameplay-loop.wav")
		arrowTimer.start()
		movingPlatform.set_physics_process(true)
		movingPlatform2.set_physics_process(true)
		movingPlatform3.set_physics_process(true)

func on_knight_timer():
	dropKnightIn = true
	player.allowedToMove = false

func on_arrow_timer():
	if !is_instance_valid(player):
		return

	if ballistaFired:
		return

	arrowSFX.volume_db = settings.GetSFXVolume(0.2)
	arrowSFX.play()

	if arrows.size() < 5:
		var temp = arrowSource.instance()
		temp.position = Vector2(player.position.x, 200)
		add_child(temp)
		arrows.append(temp)
	else:
		var temp = arrows.pop_front()
		temp.reset()
		temp.position = Vector2(player.position.x, 200)
		arrows.append(temp)

func on_player_picked_up_coin():
	arrowSFX.volume_db = settings.GetSFXVolume(0.8)
	arrowSFX.play()

	ballista.play()
	ballistaFired = true

func _on_FinalGoatTrigger_body_entered(_body:Node):
	if !shownGoatDialogue2:
		shownGoatDialogue2 = true
		goatDialogue2.Show()
