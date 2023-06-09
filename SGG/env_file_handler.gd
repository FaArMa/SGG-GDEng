extends Node
# Este script se encarga de leer y cargar variables de entorno desde un archivo .env


func _init():
	read_env_file()


func read_env_file() -> bool:
	var env_file: FileAccess = FileAccess.open("res://.env", FileAccess.READ)

	if (env_file == null):
		print("[ERROR] Ha ocurrido un error con el archivo .env: %s" % FileAccess.get_open_error())
		return false

	while (!env_file.eof_reached()):
		var current_line = env_file.get_line().strip_edges()
		var current_line_parts = current_line.split("=")
		if (current_line_parts.size() == 2):
			OS.set_environment(current_line_parts[0].strip_edges(), current_line_parts[1].strip_edges())

	env_file.close()
	return true

