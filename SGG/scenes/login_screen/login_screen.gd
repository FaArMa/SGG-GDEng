extends Control

signal switched_to_initial

@onready var DB = Database.new()
@onready var usr = $Username
@onready var pwd = $Password
@onready var error_label = $Incorrect
@onready var login_button = $Login


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	# Agregar DB como nodo hijo de LoginScreen para luego conectar con sus señales
	add_child(DB)
	DB.connect("response_user_role", _on_response_user_role)
	DB.connect("response_user_credentials", _on_response_user_credentials)
	DB.connect("response_error", _on_response_error)
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	usr.grab_focus()


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
	emit_signal("switched_to_initial")


# Se ejecuta cuando Database envia su señal de response_user_role
# TODO Agregar todos los roles que hagan falta
func _on_response_user_role(user_role):
	match user_role:
		"0":
			print("[OK] El rol del mismo es Dueño")
		"1":
			print("[OK] El rol del mismo es Gerente")
		_:
			print("[ERROR] El rol del mismo no pudo ser obtenido")


# Se ejecuta cuando Database envia su señal de response_user_credentials
func _on_response_user_credentials(are_valid_user_credentials):
	if (are_valid_user_credentials.is_empty()):
		print("[ERROR] Usuario y/o contraseña incorrectos")
		error_label.text = "Usuario y/o contraseña incorrectos"
		error_label.visible = true
	else:
		print("[OK] Usuario y contraseña correctos")
		DB.get_user_role(usr.text)
		get_tree().change_scene_to_file("res://scenes/ui/ui.tscn")


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	error_label.text = error_msg
	error_label.visible = true

