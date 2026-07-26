extends Node
@warning_ignore_start("unused_signal")

# Custom global signals for GonerEngine
# TODO PLEASE make the casing consistent!
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

# For battle
signal battle_start
## To start the battle ending animation.
signal battle_end
## Emitted once the battle has actually ended.
signal battle_end_end
signal battle_focus_charbox(party_member: PartyMember)
