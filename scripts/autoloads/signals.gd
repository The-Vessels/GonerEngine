extends Node
@warning_ignore_start("unused_signal")

# Custom global signals for GonerEngine
signal changeMusic(music, gain, pitch)
signal changeRoom(room)
signal room_change_finished
signal warpParty(marker_id, facing)
signal changeBorder(border_texture, fade_frames)
signal ToggleBorder(enable)
signal toggleMenu()
signal fadeMusic(gain, time)
signal startDialogue(text)
signal fadeFader(start, end, time)
signal fadeEnd
