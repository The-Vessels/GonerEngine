extends Node

var master_volume := 0.6

var simplify_vxf := false
var auto_run := false

var is_fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

var border_enabled := false
enum BorderModes {
	OFF = 0,
	DYNAMIC = 1,
	SIMPLE = 2,
	NONE = 3
}
var border_mode := BorderModes.OFF
