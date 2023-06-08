extends Control

signal register_screen_return

@onready var DB = Database.new()
@onready var nam = $Input_Container/Name
@onready var sur = $Input_Container/Surname
@onready var rol = $Input_Container/Role
@onready var usr = $Input_Container/Username
@onready var pwd = $Input_Container/Password
@onready var error_label = $Incorrect
@onready var register_button = $Register


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	# Agregar DB como nodo hijo de RegisterScreen para luego conectar con sus señales
	add_child(DB)
	DB.connect("response_users_count", _on_get_users_count)
	DB.connect("response_add_user", _on_response_add_user)
	DB.connect("response_error", _on_response_error)
	# ¿Hay usuarios? entonces sos un Dueño y vas a "Agregar usuario"
	# ¿No hay usuarios? entonces sos el primero (automaticamente Dueño) y vas a "Registrarte"
	# ¿Hubo un error? F en el chat
	DB.get_users_count()
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	nam.grab_focus()


# Se ejecuta cuando el texto de Name / Surname / Username / Password cambia
func _on_line_edit_text_changed(_new_text):
	register_button.disabled = false
	error_label.visible = false


# Se ejecuta cuando se presiona el boton Register
func _on_register_pressed():
	register_button.disabled = true
	# TODO Hacer una mejor restricción de lo que se puede y no escribir
	nam.text = nam.text.strip_edges()
	sur.text = sur.text.strip_edges()
	usr.text = usr.text.strip_edges()
	pwd.text = pwd.text.strip_edges()
	if (nam.text.is_empty() || sur.text.is_empty() || usr.text.is_empty() || pwd.text.is_empty()):
		print("[ERROR] Todos los campos deben ser completados")
		error_label.text = "Todos los campos deben ser completados"
		error_label.visible = true
	else:
		DB.add_new_user(nam.text, sur.text, rol.selected, usr.text, pwd.text)


# Se ejecuta cuando se presiona el boton Back
func _on_back_pressed():
	emit_signal("register_screen_return")


# Se ejecuta cuando Database envia su señal de get_users_count
func _on_get_users_count(count):
	if (!count.is_valid_int() || count.to_int() < 0):
		print("[ERROR] La cantidad de usuarios registrados no es un número válido: %s" % count)
		error_label.text = "La cantidad de usuarios registrados no es un número válido"
		error_label.visible = true
		return
	print("[OK] La cantidad de usuarios registrados es: %s" % count)
	nam.editable = true
	sur.editable = true
	usr.editable = true
	pwd.editable = true
	register_button.disabled = false
	if (count.to_int() > 0):
		rol.disabled = false
		register_button.text = "Agregar usuario"
		# TODO Se tiene que cambiar la funcionalidad del botón "Agregar usuario"
		# 1. No debe cambiar de escena tras agregar correctamente.
		# 2. Debe vaciar todos los campos así se agregará un usuario nuevo.
	else:
		rol.disabled = true


# Se ejecuta cuando Database envia su señal de response_add_user
func _on_response_add_user(register_result):
	if (register_result.is_empty()):
		print("[ERROR] Error al agregar usuario")
		error_label.text = "Error al agregar usuario"
		error_label.visible = true
	else:
		print("[OK] Usuario agregado correctamente")
		get_tree().change_scene_to_file("res://scenes/ui/ui.tscn")


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	error_label.text = error_msg
	error_label.visible = true

