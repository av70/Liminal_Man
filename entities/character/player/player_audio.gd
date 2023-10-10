extends Node3D
@onready var land_audio: AudioQueue = $LandAudio
@onready var jump_audio: AudioQueue = $JumpAudio
@onready var footstep_audio_random: AudioRandom = $FootstepAudioRandom

func play_land_audio():
	land_audio.play_audio()

func play_jump_audio():
	jump_audio.play_audio()

func play_walk_audio():
		footstep_audio_random.play_random_audio()
