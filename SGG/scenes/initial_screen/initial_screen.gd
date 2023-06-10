extends Control


signal switched_to_login
signal switched_to_register


@onready var DB = EventBus.database
@onready var login_button = $Button_Container/Login
@onready var register_button = $Button_Container/Register
@onready var error_label = $Incorrect


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	# Conectar con las señales de Database
	DB.connect("response_users_count", _on_get_users_count)
	DB.connect("response_error", _on_response_error)
	# ¿Hay usuarios? entonces vas a "Iniciar sesión"
	# ¿No hay usuarios? entonces sos el primero (automaticamente Dueño) y vas a "Registrarte"
	# ¿Hubo un error? F en el chat
	DB.get_users_count()
	await DB.httpr.request_completed
	DB.get_product_list()
	await DB.httpr.request_completed
	DB.get_available_ingredients()
	await DB.httpr.request_completed
	DB.get_product_ingredients()
	await DB.httpr.request_completed
	DB.get_product_ingredient_amounts()
	await DB.httpr.request_completed
	DB.get_user_list()
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	login_button.grab_focus()
	# Conectar la escena actual con la señal "visibility_changed"
	self.connect("visibility_changed", _on_visibility_changed)


# Se ejecuta cuando se presiona el boton Login
func _on_login_pressed():
	emit_signal("switched_to_login")


# Se ejecuta cuando se presiona el boton Register
func _on_register_pressed():
	emit_signal("switched_to_register")


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
	if (count.to_int() > 0):
		login_button.disabled = false
		login_button.grab_focus()
	else:
		register_button.disabled = false
		register_button.grab_focus()


# Se ejecuta cuando Database envia su señal de response_error
func _on_response_error(error_msg):
	if (!self.is_visible()):
		return
	error_label.text = error_msg
	error_label.visible = true


# Se ejecuta cuando la escena cambia su visibilidad
func _on_visibility_changed():
	if (self.is_visible()):
		DB.get_users_count()

