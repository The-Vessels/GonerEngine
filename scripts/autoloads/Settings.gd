extends Node

var master_volume := 0.5

var simplify_vxf := false
var auto_run := false

var is_fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

var border_enabled := false
enum BorderModes {
	DYNAMIC,
	SIMPLE,
	NONE
}
var border_mode := BorderModes.DYNAMIC
