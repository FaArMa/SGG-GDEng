extends Control

signal switched_to_login
signal switched_to_register

@onready var DB = Database.new()
@onready var login_button = $Button_Container/Login
@onready var register_button = $Button_Container/Register
@onready var error_label = $Incorrect


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	# Agregar DB como nodo hijo de InitialScreen para luego conectar con sus señales
	add_child(DB)
	DB.connect("response_users_count", _on_get_users_count)
	DB.connect("response_error", _on_response_error)
	# ¿Hay usuarios? entonces vas a "Iniciar sesión"
	# ¿No hay usuarios? entonces sos el primero (automaticamente Dueño) y vas a "Registrarte"
	# ¿Hubo un error? F en el chat
	DB.get_users_count()
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	login_button.grab_focus()


# Se ejecuta cuando se presiona el boton Login
func _on_login_pressed():
	emit_signal("switched_to_login")

# Se ejecuta cuando se presiona el boton Register
func _on_register_pressed():
	emit_signal("switched_to_register")


# Se ejecuta cuando Database envia su señal de get_users_count
func _on_get_users_count(count):
	if (!count.is_valid_int() || count.to_int() < 0):
		print("[ERROR] La cantidad de usuarios registrados no es un número válido: %s" % count)
		error_label.text = "La cantidad de usuarios registrados no es un número válido"
		error_label.visible = true
		return
	print("[OK] La cantidad de usuarios registrados es: %s" % count)
	if (count.to_int() > 0):
		login_button.disabled = false
	else:
		register_button.disabled = false


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	error_label.text = error_msg
	error_label.visible = true

