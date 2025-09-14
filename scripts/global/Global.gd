extends Node

# Documentation is here:
# https://store.steampowered.com/app/1671210/DELTARUNE/
enum {WORLD_LIGHT, WORLD_DARK}
var world_type = WORLD_LIGHT

var asp := AudioStreamPlayer.new()
