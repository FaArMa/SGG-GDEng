extends Control


signal register_screen_return

var modify_user_mode: bool:
	set(value):
		modify_user_mode = value
		title.text = "Modificar Usuario"
		register_button.text = "Modificar"
	get:
		return modify_user_mode

@onready var DB
@onready var title = $Register_Scene_Block_Container/Title
@onready var nam = $Register_Scene_Block_Container/Input_Container/Name
@onready var sur = $Register_Scene_Block_Container/Input_Container/Surname
@onready var dni = $Register_Scene_Block_Container/Input_Container/DNI
@onready var rol = $Register_Scene_Block_Container/Input_Container/Role
@onready var usr = $Register_Scene_Block_Container/Input_Container/Username
@onready var pwd = $Register_Scene_Block_Container/Input_Container/Password
@onready var error_label = $Register_Scene_Block_Container/Incorrect
@onready var register_button = $Register_Scene_Block_Container/Register
@onready var is_first_user: bool = true

func _init():
	DB = EventBus.database

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
		if modify_user_mode:
			DB.modify_user(nam.text, sur.text, dni.text.to_int(), rol.selected, usr.text, pwd.text, DatabaseContent.user_info[4].to_int())
			await DB.httpr.request_completed
			DB.get_user_list()
			emit_signal("register_screen_return")
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
	if (count.to_int() > 0) and not modify_user_mode:
		rol.disabled = false
		register_button.text = "Agregar usuario"
		is_first_user = false
	else:
		rol.disabled = true
		is_first_user = true

	if modify_user_mode:
		rol.disabled = false


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
		DB.get_user_list()
		if (is_first_user):
			get_tree().change_scene_to_file("res://scenes/ui/ui.tscn")
		self.queue_free()


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	if (!self.is_visible()):
		return
	error_label.text = error_msg
	error_label.visible = true


# Devuelve un usuario conformado por la primer letra del Name + Surname
func generate_username(_nam: String, _sur: String) -> String:
	return (_nam.substr(0, 1) + _sur).to_lower().replace(" ","")


# Devuelve una contraseña conformada por los últimos 4 dígitos del DNI
func generate_password(_dni: String) -> String:
	return _dni.substr(_dni.length() - 4, 4)


func autocomplete_user_info(_user):
	nam.text = DatabaseContent.user_info[0]
	sur.text = DatabaseContent.user_info[1]
	dni.text = DatabaseContent.user_info[2]
	rol.select(DatabaseContent.user_info[3].to_int())
	usr.text = _user
	pwd.text = dni.text.substr(dni.text.length() - 4, 4)


# Se ejecuta cuando la escena cambia su visibilidad
func _on_visibility_changed():
	if (self.is_visible()):
		DB.get_users_count()
