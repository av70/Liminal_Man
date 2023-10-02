extends Node3D
class_name AudioRandom

var audio_queue_array: Array = []
var last_queue: AudioQueue 

func _ready():
	if !get_children():
		push_error('requires children to be audio_queue')
		return
	else:
		for i in get_children():
#			var audio_duplicate = child.duplicate()
#			add_child(audio_duplicate)
			if i is AudioQueue:
				audio_queue_array.push_back(i)
			else:
				push_error('requires children to be audio_queue')
	print(audio_queue_array)
	play_random_audio()

func play_random_audio():
	var queue = audio_queue_array.pick_random()
	if queue != last_queue:
		print(queue,last_queue)
		queue.play_audio()
		last_queue = queue
	else:
		play_random_audio()
	
	print(queue)
	
func play_defined_audio(queue: AudioQueue):
	queue.play_audio()
