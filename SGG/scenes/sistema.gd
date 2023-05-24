extends Node

const MIN_WINDOW_SIZE = Vector2i(1280,720)
var _session_state: SessionSave
var current_table_positions: Dictionary = {}

func _ready():
	EventBus.connect("tables_modified", _on_tables_modified)
	_session_state = SessionSave.new()
	print("- Cargando Ubicación de Mesas -")
	current_table_positions = _session_state.load_state(current_table_positions)
	EventBus.emit_signal("tables_loaded", current_table_positions)
	DisplayServer.window_set_min_size(MIN_WINDOW_SIZE)
	#DisplayServer.window_get_size()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_session_state = SessionSave.new()
		_session_state.save_state(current_table_positions)
		#	GUARDADO DE DATOS Y MESAS	#
		print("- Cerrando Sistema -")
		get_tree().quit()

func _on_tables_modified(_tables: Dictionary):
	_session_state = SessionSave.new()
	current_table_positions = _tables
	_session_state.save_state(current_table_positions)
	
#func inicio_sesión(sesion):
#	if sesion == dueño:
#		ui.emit_signal("editar_mesas_avaiable")
