extends Node3D
#var last_step_time: float = 0
@onready var land_audio: AudioQueue = $LandAudio
@onready var jump_audio: AudioQueue = $JumpAudio
@onready var footstep_audio_random: AudioRandom = $FootstepAudioRandom



func play_land_audio():
	land_audio.play_audio()

func play_jump_audio():
	jump_audio.play_audio()

func play_walk_audio(delta: float,current_speed: float):
#		last_step_time = last_step_time+delta
#		if last_step_time > 2/current_speed:
		footstep_audio_random.play_random_audio()
		print(2/current_speed)
#			last_step_time = 0
