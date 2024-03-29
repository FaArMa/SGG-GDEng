extends Control


signal login_screen_return
signal switched_to_ui
signal role_checked(username)

var http_request = false

@onready var DB = EventBus.database
@onready var usr = $Block_Container/Username
@onready var pwd = $Block_Container/Password
@onready var error_label = $Block_Container/Incorrect
@onready var login_button = $Block_Container/Login


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	# Conectar con las señales de Database
	DB.connect("response_user_role", _on_response_user_role)
	DB.connect("response_user_credentials", _on_response_user_credentials)
	DB.connect("response_error", _on_response_error)

	if EventBus.is_popup_login:
		$Block_Container/Background.hide()
		$Block_Container/Background_Small.show()


# Se ejecuta cuando se presiona el boton Login
func _on_button_login_pressed():
	login_button.disabled = true
	# TODO Hacer una mejor restricción de lo que se puede y no escribir
	usr.text = usr.text.strip_edges()
	pwd.text = pwd.text.strip_edges()
	if (usr.text.is_empty() || pwd.text.is_empty()):
		print("[ERROR] Todos los campos deben ser completados")
		error_label.text = "Todos los campos deben ser completados"
		error_label.visible = true
	else:
		DB.is_valid_user_password(usr.text, pwd.text)


# Se ejecuta cuando el texto de Username / Password cambia
func _on_line_edit_text_changed(_new_text):
	login_button.disabled = false
	error_label.visible = false


# Se ejecuta cuando se presiona el boton Back
func _on_button_back_pressed():
	if not EventBus.is_popup_login:
		emit_signal("login_screen_return")
	else:
		self.queue_free()


# Se ejecuta cuando Database envia su señal de response_user_role
func _on_response_user_role(user_role):
	if (!self.is_visible()):
		return
	match user_role:
		"0":
			print("[OK] El rol del mismo es Dueño")
		"1":
			print("[OK] El rol del mismo es Encargado")
		"2":
			print("[OK] El rol del mismo es Empleado")
		"3":
			print("[OK] El rol del mismo es Contador")
		_:
			print("[ERROR] El rol del mismo no pudo ser obtenido")
	if not EventBus.is_popup_login:
		emit_signal("switched_to_ui")
	else:
		emit_signal("role_checked", usr.text)
		self.queue_free()


# Se ejecuta cuando Database envia su señal de response_user_credentials
func _on_response_user_credentials(are_valid_user_credentials):
	if (!self.is_visible()):
		return
	if (are_valid_user_credentials.is_empty()):
		print("[ERROR] Usuario y/o contraseña incorrectos")
		error_label.text = "Usuario y/o contraseña incorrectos"
		error_label.visible = true
	else:
		print("[OK] Usuario y contraseña correctos")
		if !http_request:
			DB.get_user_role(usr.text)
			http_request = true


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	if (!self.is_visible()):
		return
	error_label.text = error_msg
	error_label.visible = true


# Se ejecuta cuando la escena cambia su visibilidad
func _on_visibility_changed():
#	if (self.is_visible()):
#		usr.grab_focus()
	pass
