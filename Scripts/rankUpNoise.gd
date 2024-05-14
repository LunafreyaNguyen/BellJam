extends AudioStreamPlayer2D

func playPitch(range, from_position = 0.0): 
	pitch_scale = range
	play(from_position)
