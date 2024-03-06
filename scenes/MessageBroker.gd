extends Node

signal player_died
signal player_picked_up_key
signal player_entered_door_unlock(doorid)
signal player_unlocked_door(doorid)
signal player_picked_up_coin
signal player_picked_up_gem
signal player_picked_up_food

signal camera_shake

signal show_gameover_screen

signal load_main_menu
signal selected_user_file(userFile)

signal player_entered_portal()
signal load_level(nextLevel)

signal open_world_select
signal change_world_select_index(index)
signal world_select_clicked

signal play_music(music)
signal stop_music

signal changed_music_volume(volume)

signal dialogue_complete