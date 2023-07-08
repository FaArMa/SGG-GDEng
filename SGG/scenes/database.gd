class_name Database
extends Node
# La clase se encarga de enviar peticiones POST al SGG-Web y este se encarga de consultar con MySQL


signal response_users_count(count)
signal response_user_role(user_role)
signal response_user_credentials(are_valid_user_credentials)
signal response_add_user(register_result)
signal response_update_ingredient_stock_decrease(update_successfully)
signal response_update_ingredient_stock_increase(update_successfully)
signal response_check_ingredient_stock(update_successfully)
signal response_error(error_msg)


const headers: Array = ["Content-Type: application/x-www-form-urlencoded"]
var url: String = OS.get_environment("API_URL")
var data: Dictionary
var httpr: HTTPRequest
var httpc: HTTPClient


func _init():
	print("- Constructor de Database -")
	httpr = HTTPRequest.new()
	httpc = HTTPClient.new()
	# HTTPRequest tiene que ser un nodo hijo de Node (y justo Database extiende de Node)
	add_child(httpr)
	httpr.timeout = 3.0
	httpr.request_completed.connect(_on_httpr_request_completed)


func _ready():
	await httpr.request_completed
	get_user_list()
	await httpr.request_completed
	update_products()


func update_products():
	get_product_list()
	await httpr.request_completed
	get_available_ingredients() # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR
	await httpr.request_completed
	get_product_ingredients()
	await httpr.request_completed
	get_product_ingredient_amounts()


func get_user_list() -> void:
	data = {"action": "get_user_list"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	await httpr.request_completed
	http_error_exists(httpr, result)
	return


func get_product_list() -> void:
	data = {"action": "get_product_list"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func get_available_ingredients() -> void: # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR
	data = {"action": "get_available_ingredients"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func get_product_ingredients() -> void:
	data = {"action": "get_product_ingredients"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func get_product_ingredient_amounts() -> void:
	data = {"action": "get_product_ingredient_amounts"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func modify_ingredient_stock(_ingredient_name, _stock) -> void:
	data = {"action": "modify_ingredient_stock", "nombre_ingrediente": _ingredient_name, "stock": _stock}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func update_ingredient_stock_decrease(_product_name, _amount) -> void:
	data = {"action": "update_ingredient_stock_decrease", "nombre_producto": _product_name, "cantidad": _amount}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func update_ingredient_stock_increase(_product_name, _amount) -> void:
	data = {"action": "update_ingredient_stock_increase", "nombre_producto": _product_name, "cantidad": _amount}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func check_ingredient_stock(_product_name, _amount) -> void:
	data = {"action": "check_ingredient_stock", "nombre_producto": _product_name, "cantidad": _amount}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func modify_product_data(new_price, new_product_name, old_product_name) -> void:
	data = {"action": "modify_product_data", "nuevo_precio": new_price, "nuevo_nombre_producto": new_product_name, "viejo_nombre_producto": old_product_name}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func add_product(product_name, type, price, ingredients) -> void:
	data = {"action": "add_product", "nombre": product_name, "tipo": type, "precio": price, "ingredientes": ingredients}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func delete_product(product) -> void:
	data = {"action": "delete_product", "nombre_producto": product}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func delete_user(username) -> void:
	data = {"action": "delete_user", "username": username}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func get_user_info(username) -> void:
	data = {"action": "get_user_info", "username": username}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func generate_bill(table_name, username, products) -> void:
	data = {"action": "generate_bill", "mesa": table_name, "nombre_usuario": username, "productos": products}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func billing_search(from, to) -> void:
	data = {"action": "billing_search", "desde": from, "hasta": to}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


# Obtener la cantidad de usuarios registrados
func get_users_count() -> void:
	data = {"action": "get_users_count"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


# Obtener el rol del usuario
func get_user_role(_user: String) -> void:
	data = {"username": _user, "action": "get_user_role"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


# Verificar si el usuario y contraseña son correctos
func is_valid_user_password(_user: String, _password: String) -> void:
	data = {"username": _user, "password": _password, "action": "validate_user_credentials"}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


# Registrar / Agregar un nuevo usuario
func add_new_user(_name: String, _surname: String, _dni: int, _role: int, _username: String, _password: String) -> void:
	data = {
		"name": _name,
		"surname": _surname,
		"dni": _dni,
		"role": _role,
		"username": _username,
		"password": _password,
		"action": "add_user"
	}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


func modify_user(_name: String, _surname: String, _dni: int, _role: int, _username: String, _password: String, _id: int) -> void:
	data = {
		"name": _name,
		"surname": _surname,
		"dni": _dni,
		"role": _role,
		"username": _username,
		"password": _password,
		"user_id": _id,
		"action": "modify_user"
	}
	var body = httpc.query_string_from_dict(data)
	var result = httpr.request(url, headers, HTTPClient.METHOD_POST, body)
	http_error_exists(httpr, result)
	return


# Se ejecuta siempre que se complete un HTTPRequest.request()
func _on_httpr_request_completed(_result, _response_code, _headers, _body) -> void:
	# Ya no hace falta la conexión y se cierra para poder reutilizar este HTTPClient
	httpc.close()
	# Hacer que _body sea texto y no una secuencia de bytes
	_body = _body.get_string_from_utf8()
	# DEBUG Solamente muestra todo lo que ha devuelto el servidor
	#print("\n- Result: %s\n- Response code: %s\n- Headers: %s\n- Body: %s" % [_result, _response_code, _headers, _body])

	# Determinar si hubo un error con el servidor
	if (http_error_exists(httpc, _result, _response_code, _body)):
		return

	# Enviar la señal que corresponda
	match data["action"]:
		"billing_search":
			EventBus.emit_signal("response_billing_search", _body)
		"get_user_info":
			EventBus.emit_signal("response_get_user_info", _body)
		#INGREDIENTES POR PRODUCTO Y SUS UNIDADES
		"get_available_ingredients": # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR
			EventBus.emit_signal("response_available_ingredients", _body)
		#CANTIDAD DE INGREDIENTES POR PRODUCTO DISPONIBLE
		"get_product_ingredient_amounts":
			EventBus.emit_signal("response_product_ingredient_amount_list", _body)
		#PRODUCTOS, PRECIOS Y TIPO
		"get_product_list":
			EventBus.emit_signal("response_product_list", _body)
		#INGREDIENTES POR PRODUCTO DISPONIBLE
		"get_product_ingredients":
			EventBus.emit_signal("response_product_ingredient_list", _body)
		"get_user_list":
			EventBus.emit_signal("response_get_user_list", _body)
		"get_users_count":
			emit_signal("response_users_count", _body)
		"get_user_role":
			emit_signal("response_user_role", _body)
		"validate_user_credentials":
			emit_signal("response_user_credentials", _body)
		"add_user":
			emit_signal("response_add_user", _body)
		"update_ingredient_stock_decrease":
			emit_signal("response_update_ingredient_stock_decrease", _body)
		"update_ingredient_stock_increase":
			emit_signal("response_update_ingredient_stock_increase", _body)
		"check_ingredient_stock":
			emit_signal("response_check_ingredient_stock", _body)
		_:
			print("[WARN] Action: No se utiliza localmente.")
			emit_signal("response_error", "Action: No se utiliza localmente.")

	# Todo se termino
	return


# Determinar si hubo un error con HTTPRequest o HTTPClient
func http_error_exists(_http, _result, _response_code = null, _body = null) -> bool:
	# Determinar si el HTTPRequest.request() tuvo un error
	if (_http is HTTPRequest):
		if (_result != OK):
			print("[ERROR] Ha ocurrido un error en la petición HTTP: %s" % _result)
			emit_signal("response_error", "Ha ocurrido un error en la petición HTTP: %s" % _result)
			httpr.cancel_request()
			httpc.close()
			return true

	# Determinar si el HTTPClient.request() tuvo un error
	if (_http is HTTPClient):
		# Si el servidor no responde...
		if (_result != OK):
			print("[ERROR] Ha ocurrido un error en la respuesta del servidor: %s" % _result)
			emit_signal("response_error", "Ha ocurrido un error en la respuesta del servidor: %s" % _result)
			return true

		# Si el servidor responde pero no con el código esperado...
		elif (_response_code != HTTPClient.RESPONSE_OK):
			print("[ERROR] El servidor ha devuelto el siguiente estado de respuesta HTTP: %s - %s" % [_response_code, _body])
			emit_signal("response_error", "El servidor ha devuelto el siguiente estado de respuesta HTTP: %s" % _response_code)
			return true

	# No hay ningun error
	return false

