extends Node

const MIN_WINDOW_SIZE = Vector2i(1280,720)


func _ready():
	DisplayServer.window_set_min_size(MIN_WINDOW_SIZE)
	#DisplayServer.window_get_size()


#func inicio_sesión(sesion):
#	if sesion == dueño:
#		ui.emit_signal("editar_mesas_avaiable")


