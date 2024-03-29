
extends Node3D
class_name AudioQueue

@export var count: int = 5
var audio_player_array: Array = []

func _ready():
	if !get_children():
		push_error('requires single audio_stream_player child')
		return
	var child = get_child(0)
	if child is AudioStreamPlayer3D or child is AudioStreamPlayer2D or child is AudioStreamPlayer:
		audio_player_array.insert(0,child)
		for i in count-1:
			var audio_duplicate = child.duplicate()
			add_child(audio_duplicate)
			audio_player_array.push_back(audio_duplicate)
	else:
		push_error('requires single audio_stream_player3d child')

func play_audio():
	for i in count-1:
		if !get_child(i).playing:
			var player = audio_player_array[i]
			player.play(0)
			break
