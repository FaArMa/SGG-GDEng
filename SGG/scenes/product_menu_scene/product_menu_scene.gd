extends Control

signal ingredients_available

@onready var existing_products: Dictionary = {}
@onready var existing_ingredients: Dictionary = {}

@onready var single_line_input_scene = preload("res://scenes/Single_Line_Input_Scene/single_line_input.tscn")

#	PRODUCTOS
#	{
#		"Fernet C/Coca": [[1200, "bebida"], ["fernet", "coca"], [0.06, 0.24]],
#		"Hamburguesa con Lechuga": [[2300, "comida"], ["carne", "pan", "lechuga"], [210, 150, 40]],
#		"Fugazzeta": [[1900, "comida"], ["masa", "cebolla"], [400, 350]]
#	}
#
#	INGREDIENTES
#{
#	"carne": "gr",
#	"fernet": "lt",
#	"coca": "lt",
#	"cebolla": "gr"
#}

var selected_product_name
var new_product: Array = []
var new_product_ingredients: Dictionary = {}

var Existing_Product_Name
var Existing_Product_Price
var Existing_Product_Type

var Existing_Ingredient_Name
var Selected_Ingredient_Name

var Modify_Product
var Delete_Product

var Confirm_Dialog

var New_Product_Name_Input
var New_Product_Price
var New_Product_Type

var New_Product_Select_Ingredient

var Ingredient_Add_Quantity_Input
var Add_Ingredient_Quantity
var Ingredient_Remove_Quantity_Input
var Remove_Ingredient_Quantity
var Add_New_Ingredient

var Add_New_Product

func _ready():

	EventBus.connect("response_product_list", _on_response_product_list)
	EventBus.connect("response_product_ingredient_list", _on_response_ingredient_list)

	self.connect("ingredients_available", _on_selected_ingredients_changed)

	existing_products = DatabaseContent.product_list
	existing_ingredients = DatabaseContent.all_available_ingredients

	#NODE DEFINITIONS
	Existing_Product_Name = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Text_Container/Existing_Product_Name
	Existing_Product_Price = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Text_Container/Existing_Product_Price
	Existing_Product_Type = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Text_Container/Existing_Product_Type

	Existing_Ingredient_Name = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Ingredient_Container/Existing_Ingredient_Name
	Selected_Ingredient_Name = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Selected_Ingredient_Container/Selected_Ingredient_Name

	Modify_Product = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Button_Container/Modify_Product
	Delete_Product = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Button_Container/Delete_Product

	Confirm_Dialog = $Product_Menu_Block_Container/Confirm_Dialog

	New_Product_Name_Input = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/New_Product_Input_Container/New_Product_Text_Container/Product_Name
	New_Product_Price = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/New_Product_Input_Container/New_Product_Text_Container/Product_Price
	New_Product_Type = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/New_Product_Input_Container/New_Product_Text_Container/New_Product_Type

	New_Product_Select_Ingredient = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/New_Product_Input_Container/New_Product_Button_Container/New_Product_Select_Ingredient

	Ingredient_Add_Quantity_Input = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Ingredient_Container/Existing_Ingredient_Quantity
	Add_Ingredient_Quantity = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Ingredient_Container/Existing_Ingredient_Add
	Ingredient_Remove_Quantity_Input = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Selected_Ingredient_Container/Selected_Ingredient_Quantity
	Remove_Ingredient_Quantity = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Selected_Ingredient_Container/Selected_Ingredient_Remove
	Add_New_Ingredient = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Ingredient_Container/New_Ingredient_Add

	Add_New_Product = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Add_New_Product

	new_product.resize(3)

	load_existing_products()
	load_existing_ingredients()

	Existing_Product_Name.selected = -1


func _on_response_product_list(_product):
	load_existing_products()


func _on_response_ingredient_list(_ingredient):
	load_existing_ingredients()


func load_existing_products():
	Existing_Product_Name.clear()

	existing_products = DatabaseContent.product_list

	for i in existing_products.keys():
		Existing_Product_Name.add_item(i)

	Existing_Product_Name.selected = -1
	Existing_Product_Price.clear()
	Existing_Product_Type.selected = -1


func load_existing_ingredients(): # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR # MODIFICAR
	Existing_Ingredient_Name.clear()

	existing_ingredients = DatabaseContent.all_available_ingredients

	for i in existing_ingredients.keys():
			Existing_Ingredient_Name.add_item(i)


func _on_exit_button_pressed():
	self.queue_free()


func _on_existing_product_name_item_selected(index):
	Modify_Product.disabled = false
	Delete_Product.disabled = false
	New_Product_Select_Ingredient.disabled = true
	New_Product_Name_Input.set_text("") # .clear() rompe Existing_Product_Name ?!
	New_Product_Price.clear()
	New_Product_Type.selected = -1

	Selected_Ingredient_Name.clear()
	selected_product_name = Existing_Product_Name.get_item_text(index)
	Existing_Product_Price.set_text(str(existing_products[selected_product_name][0][0]))
	Existing_Product_Type.selected = 1 if existing_products[selected_product_name][0][1] == "bebida" else 0

	var product_ingredient
	var ingredient_name
	var ingredient_unit
	var ingredient_amount

	for i in existing_products[selected_product_name][1].size():

		ingredient_name = existing_products[selected_product_name][1][i]
		ingredient_amount = existing_products[selected_product_name][2][i]
		ingredient_unit = existing_ingredients[ingredient_name]

		product_ingredient = "%s, %s %s" % [ingredient_name, ingredient_amount, ingredient_unit]
		Selected_Ingredient_Name.add_item(product_ingredient)


func _on_modify_product_pressed():
	if not Existing_Product_Name.selected == -1:
		var input = single_line_input_scene.instantiate()
		input.connect("text_submit", _on_text_submit.bind(0))
		input.product_menu = true
		add_child(input)


func _on_text_submit(_extra_input, _name, _is_ingredient):
	var DB = EventBus.database

	if not _is_ingredient:
		DB.modify_product_data(_extra_input, _name, selected_product_name)
		await DB.httpr.request_completed
		DB.update_products()
	else:
		Existing_Ingredient_Name.add_item(_name)
		existing_ingredients[_name] = _extra_input


func _on_delete_product_pressed():
	if not Existing_Product_Name.selected == -1:
		Confirm_Dialog.show()


func _on_cancel_button_pressed():
	Confirm_Dialog.hide()


func _on_accept_button_pressed():
	var DB = EventBus.database

	DB.delete_product(Existing_Product_Name.text)
	await DB.httpr.request_completed
	DB.update_products()
	existing_products.erase(Existing_Product_Name.text)
	Selected_Ingredient_Name.clear()
	# FIXME Al eliminar el último producto que queda, no se borran sus ingredientes!
	Confirm_Dialog.hide()


func _on_product_name_text_changed(new_product_name):
	if not New_Product_Name_Input.text == "":
		Existing_Product_Name.selected = -1
		Existing_Product_Price.clear()
		Existing_Product_Type.selected = -1
		Selected_Ingredient_Name.clear()
		Modify_Product.disabled = true
		Delete_Product.disabled = true

		New_Product_Price.editable = true
		New_Product_Select_Ingredient.disabled = false
	else:
		New_Product_Price.editable = false
		New_Product_Select_Ingredient.disabled = true

	new_product_name = new_product_name.strip_edges(true,true)
	new_product_name = new_product_name.to_lower()
	new_product_name = new_product_name.capitalize()

	new_product[0] = new_product_name


func _on_product_price_text_changed(new_product_price):
	if not New_Product_Price.text == "":
		New_Product_Type.disabled = false
	else:
		New_Product_Type.disabled = true

	new_product_price = new_product_price.strip_edges(true,true)
	new_product_price = new_product_price.replace(" ","")

	if new_product_price.is_valid_float():
		new_product[1] = new_product_price
	else:
		print("[ERROR] Precio no válido")
		new_product[1] = 0


func _on_new_product_type_item_selected(index):
	var type = New_Product_Type.get_item_text(index)
	type = type.to_lower()
	new_product[2] = type


func _on_new_product_select_ingredient_pressed():
	Ingredient_Add_Quantity_Input.editable = true
	Add_Ingredient_Quantity.disabled = false
	Ingredient_Remove_Quantity_Input.editable = true
	Remove_Ingredient_Quantity.disabled = false
	Add_New_Ingredient.disabled = false


func _on_existing_ingredient_add_pressed():
	if Existing_Ingredient_Name.is_anything_selected() and not Ingredient_Add_Quantity_Input.text == "" and Ingredient_Add_Quantity_Input.text.is_valid_float():
		var ingredient_name = Existing_Ingredient_Name.get_item_text(Existing_Ingredient_Name.get_selected_items()[0])
		var ingredient_type = existing_ingredients[ingredient_name]
		var ingredient_amount = Ingredient_Add_Quantity_Input.text.to_float()

		Selected_Ingredient_Name.clear()

		if new_product_ingredients.has(ingredient_name):
			new_product_ingredients[ingredient_name][0] += ingredient_amount
		else:
			new_product_ingredients[ingredient_name] = [ingredient_amount, ingredient_type]

		for i in new_product_ingredients.keys():
			Selected_Ingredient_Name.add_item("%s, %.2f %s" % [i, new_product_ingredients[i][0], new_product_ingredients[i][1]])
		emit_signal("ingredients_available")


func _on_selected_ingredient_remove_pressed():
	if Selected_Ingredient_Name.is_anything_selected() and not Ingredient_Remove_Quantity_Input.text == "" and Ingredient_Remove_Quantity_Input.text.is_valid_float():
		var ingredient_name

		for i in new_product_ingredients.keys():
			if Selected_Ingredient_Name.get_item_text(Selected_Ingredient_Name.get_selected_items()[0]).contains(i):
				ingredient_name = i

		var ingredient_amount = Ingredient_Remove_Quantity_Input.text.to_float()
		var remove_amount = new_product_ingredients[ingredient_name][0] - ingredient_amount

		Selected_Ingredient_Name.clear()

		if remove_amount <= 0:
			new_product_ingredients.erase(ingredient_name)
		else:
			new_product_ingredients[ingredient_name][0] = remove_amount

		for i in new_product_ingredients.keys():
			Selected_Ingredient_Name.add_item("%s, %.2f %s" % [i, new_product_ingredients[i][0], new_product_ingredients[i][1]])
		emit_signal("ingredients_available")


func _on_selected_ingredients_changed():
	if not new_product_ingredients.is_empty():
		Add_New_Product.disabled = false
	else:
		Add_New_Product.disabled = true


func _on_add_new_product_pressed():
	var DB = EventBus.database

	DB.add_product(new_product[0],new_product[2],new_product[1],new_product_ingredients)
	await DB.httpr.request_completed
	DB.update_products()

	Selected_Ingredient_Name.clear()
	New_Product_Name_Input.set_text("")
	New_Product_Price.clear()
	Ingredient_Add_Quantity_Input.clear()
	Ingredient_Remove_Quantity_Input.clear()

	New_Product_Price.editable = false
	New_Product_Type.disabled = true
	Ingredient_Add_Quantity_Input.editable = false
	Ingredient_Remove_Quantity_Input.editable = false
	New_Product_Select_Ingredient.disabled = true
	Add_New_Ingredient.disabled = true
	Add_Ingredient_Quantity.disabled = true
	Remove_Ingredient_Quantity.disabled = true
	Add_New_Product.disabled = true
	new_product_ingredients.clear()


func _on_new_ingredient_add_pressed():
	if not New_Product_Name_Input.text == "":
		var input = single_line_input_scene.instantiate()
		input.connect("text_submit", _on_text_submit.bind(1))
		input.product_menu_add_ingredient = true
		add_child(input)
