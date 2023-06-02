class_name SessionSave
extends Node

const SAVE_PATH := "user://session_save.cfg"


func save_state(tables: Dictionary, walls: Array):
	var config = ConfigFile.new()

	config.set_value("Objects", "Tables", tables)
	config.set_value("Objects", "Walls", walls)

	config.save(SAVE_PATH)
	print("- Objetos Guardados -")


func load_state(tables: Dictionary, walls: Array):
	var config = ConfigFile.new()

	var err = config.load(SAVE_PATH)

	if err != OK:
		print("- Error Cargando Objetos -")
		save_state(tables, walls)

	return [config.get_value("Objects", "Tables", tables), config.get_value("Objects", "Walls", walls)]

