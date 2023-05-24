class_name SessionSave
extends Node

const SAVE_PATH := "user://session_save.save"
var stored_table_positions: Dictionary = {}

func save_state(_table_positions: Dictionary):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(_table_positions)
	stored_table_positions = _table_positions
	file.close()
	print("- Ubicación de Mesas Guardada -")

func load_state(_table_positions: Dictionary):
	if not FileAccess.file_exists(SAVE_PATH):
		print("- Archivo No Encontrado -")
		save_state(_table_positions)
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	stored_table_positions = file.get_var()
	file.close()
	print("- Ubicación de Mesas Cargada -")
	return stored_table_positions
