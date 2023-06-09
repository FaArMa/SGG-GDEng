extends Control


signal register_screen_return


@onready var DB = EventBus.database
@onready var nam = $Input_Container/Name
@onready var sur = $Input_Container/Surname
@onready var dni = $Input_Container/DNI
@onready var rol = $Input_Container/Role
@onready var usr = $Input_Container/Username
@onready var pwd = $Input_Container/Password
@onready var error_label = $Incorrect
@onready var register_button = $Register
@onready var is_first_user: bool = true


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	# Conectar con las señales de Database
	DB.connect("response_users_count", _on_get_users_count)
	DB.connect("response_add_user", _on_response_add_user)
	DB.connect("response_error", _on_response_error)


# Se ejecuta cuando el texto de Name / Surname / DNI / Username / Password cambia
func _on_line_edit_text_changed(_new_text):
	register_button.disabled = false
	error_label.visible = false
	if (!nam.text.is_empty() && !sur.text.is_empty() && !dni.text.is_empty()):
		usr.text = generate_username(nam.text, sur.text)
		pwd.text = generate_password(dni.text)


# Se ejecuta cuando se presiona el boton Register
func _on_register_pressed():
	register_button.disabled = true
	# TODO Hacer una mejor restricción de lo que se puede y no escribir
	nam.text = nam.text.strip_edges()
	sur.text = sur.text.strip_edges()
	dni.text = dni.text.strip_edges()
	usr.text = usr.text.strip_edges()
	pwd.text = pwd.text.strip_edges()
	if (nam.text.is_empty() || sur.text.is_empty() || dni.text.is_empty() || usr.text.is_empty() || pwd.text.is_empty()):
		print("[ERROR] Todos los campos deben ser completados")
		error_label.text = "Todos los campos deben ser completados"
		error_label.visible = true
	elif (!dni.text.is_valid_int() || dni.text.to_int() < 1000 || dni.text.to_int() > 99999999):
		print("[ERROR] El DNI debe ser un número entre 1.000 y 99.999.999")
		error_label.text = "El DNI debe ser un número entre 1.000 y 99.999.999"
		error_label.visible = true
	else:
		DB.add_new_user(nam.text, sur.text, dni.text.to_int(), rol.selected, usr.text, pwd.text)


# Se ejecuta cuando se presiona el boton Back
func _on_back_pressed():
	emit_signal("register_screen_return")


# Se ejecuta cuando Database envia su señal de get_users_count
func _on_get_users_count(count):
	if (!self.is_visible()):
		return
	if (!count.is_valid_int() || count.to_int() < 0):
		print("[ERROR] La cantidad de usuarios registrados no es un número válido: %s" % count)
		error_label.text = "La cantidad de usuarios registrados no es un número válido"
		error_label.visible = true
		return
	print("[OK] La cantidad de usuarios registrados es: %s" % count)
	nam.editable = true
	sur.editable = true
	dni.editable = true
	register_button.disabled = false
	if (count.to_int() > 0):
		rol.disabled = false
		register_button.text = "Agregar usuario"
		is_first_user = false
	else:
		rol.disabled = true
		is_first_user = true
	nam.grab_focus()


# Se ejecuta cuando Database envia su señal de response_add_user
func _on_response_add_user(register_result):
	if (!self.is_visible()):
		return
	if (register_result.is_empty()):
		print("[ERROR] Error al agregar usuario")
		error_label.text = "Error al agregar usuario"
		error_label.visible = true
	else:
		print("[OK] Usuario agregado correctamente")
		if (is_first_user):
			get_tree().change_scene_to_file("res://scenes/ui/ui.tscn")
		else:
			clear_input_data()
			nam.grab_focus()


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	if (!self.is_visible()):
		return
	error_label.text = error_msg
	error_label.visible = true


# Devuelve un usuario conformado por la primer letra del Name + Surname
func generate_username(_nam: String, _sur: String) -> String:
	return (_nam.substr(0, 1) + _sur).to_lower()


# Devuelve una contraseña conformada por los últimos 4 dígitos del DNI
func generate_password(_dni: String) -> String:
	return _dni.substr(_dni.length() - 4, 4)


# Vacia todos los campos escritos por el usuario
func clear_input_data() -> void:
	nam.text = ""
	sur.text = ""
	dni.text = ""
	rol.select(0)
	usr.text = ""
	pwd.text = ""
	return


# Se ejecuta cuando la escena cambia su visibilidad
func _on_visibility_changed():
	if (self.is_visible()):
		DB.get_users_count()

