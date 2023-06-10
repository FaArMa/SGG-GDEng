extends Node

const MIN_WINDOW_SIZE = Vector2i(1280,720)


func _ready():
	DisplayServer.window_set_min_size(MIN_WINDOW_SIZE)


