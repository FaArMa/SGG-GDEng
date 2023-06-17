#DatabaseContent Singleton
extends Node

#--------------------- PRODUCTOS E INGREDIENTES ---------------------#
@onready var product_list: Dictionary = {}
@onready var ingredient_list: Array = []
@onready var ingredient_amount_list: Array = []
@onready var all_available_ingredients: Dictionary = {}

#--------------------- USUARIOS ---------------------#
@onready var user_list: Dictionary = {}
@onready var user_info: Array = []

#--------------------- RESPUESTA FACTURA ----------------------#
@onready var bill_list: Dictionary = {}


func _ready():
#--------------------- RESPUESTA PRODUCTOS E INGREDIENTES ---------------------#
	EventBus.connect("response_product_list", _on_get_product_list)
	EventBus.connect("response_modify_product", _on_get_product_list)
	EventBus.connect("response_available_ingredients", _on_get_available_ingredients) # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR
	EventBus.connect("response_product_ingredient_list", _on_get_product_ingredient_list)
	EventBus.connect("response_product_ingredient_amount_list", _on_get_product_ingredient_amount_list)

#--------------------- RESPUESTA USUARIOS ---------------------#
	EventBus.connect("response_get_user_list", _on_get_user_list)
	EventBus.connect("response_get_user_info", _on_get_user_info)

#--------------------- RESPUESTA FACTURA ----------------------#
	EventBus.connect("response_billing_search", _on_response_billing_search)


#--------------------- PRODUCTOS E INGREDIENTES ---------------------#

# Listado de productos, sus precios y tipos
func _on_get_product_list(products):
	product_list.clear()

	var product_array = products.split(",")
	var items_per_product = 3
	var total_products = product_array.size()
	for i in total_products:
		if (i % items_per_product):
			continue
		product_list[product_array[i]] = [[product_array[i+1],product_array[i+2]]]


# Listado de ingredientes totales
func _on_get_available_ingredients(available_ingredients):
	all_available_ingredients.clear()

	var available_ingredient_array = available_ingredients.split(",")
	var items_per_ingredient = 2
	var total_ingredients = available_ingredient_array.size()
	for i in total_ingredients:
		if (i % items_per_ingredient):
			continue
		all_available_ingredients[available_ingredient_array[i]] = available_ingredient_array[i+1]


# Listado de ingredientes separados por producto
func _on_get_product_ingredient_list(ingredients):
	ingredient_list.clear()

	var json_reader = JSON.new()
	if json_reader.parse(ingredients) == OK:
		ingredient_list = json_reader.get_data()

	var k = 0
	for i in product_list.keys():
		product_list[i].append(ingredient_list[k])
		k += 1


# Listado de cantidades de cada ingrediente separados por producto
func _on_get_product_ingredient_amount_list(amounts):
	ingredient_amount_list.clear()

	var json_reader = JSON.new()
	if json_reader.parse(amounts) == OK:
		ingredient_amount_list = json_reader.get_data()

	var k = 0
	for i in product_list.keys():
		product_list[i].append(ingredient_amount_list[k])
		k += 1


#--------------------- USUARIOS ---------------------#

# Listado de usuarios y sus roles
func _on_get_user_list(users):
	user_list.clear()

	var users_array = users.split(",")
	var items_per_user = 2
	var total_users = users_array.size()
	for i in total_users:
		if (i % items_per_user):
			continue
		user_list[users_array[i]] = users_array[i+1]
	EventBus.emit_signal("user_list_updated")


func _on_get_user_info(user):
	user_info.clear()

	var user_info_array = user.split(",")
	for i in user_info_array:
		user_info.append(i)


#--------------------- FACTURA ----------------------#
func _on_response_billing_search(result):
	if not result.is_empty():
		bill_list.clear()

		var bill_array = result.split(",")
		var items_per_bill = 4
		var total_bills = bill_array.size()
		for i in total_bills:
			if (i % items_per_bill):
				continue
			bill_list[bill_array[i]] = [bill_array[i+1], bill_array[i+2], bill_array[i+3]]
		EventBus.emit_signal("billing_list_updated")
