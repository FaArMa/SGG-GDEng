extends Control

signal text_submit(text)

var product_menu: bool:
	set(value):
		product_menu = value
		if value:
			$Input_Block_Container/Input_Menu_Container/Title.text = "Modificar Producto"
			$Input_Block_Container/Input_Menu_Container/Input_Container/Input.max_length = 40
			$Input_Block_Container/Input_Menu_Container/Input_Container/Product_Price.show()
		else:
			$Input_Block_Container/Input_Menu_Container/Input_Container/Input.max_length = 4
			$Input_Block_Container/Input_Menu_Container/Input_Container/Product_Price.hide()
	get:
		return product_menu

var product_menu_add_ingredient: bool:
	set(value):
		product_menu_add_ingredient = value
		if value:
			$Input_Block_Container/Input_Menu_Container/Title.text = "Crear Nuevo Ingrediente"
			$Input_Block_Container/Input_Menu_Container/Input_Container/Input.max_length = 40
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Unit.show()
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.show()
		else:
			$Input_Block_Container/Input_Menu_Container/Input_Container/Input.max_length = 4
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Unit.hide()
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.hide()
	get:
		return product_menu_add_ingredient

var modify_ingredient_stock: bool:
	set(value):
		modify_ingredient_stock = value
		if value:
			$Input_Block_Container/Input_Menu_Container/Title.text = "Modificar Stock de Ingrediente"
			$Input_Block_Container/Input_Menu_Container/Input_Container/Input.hide()
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.custom_minimum_size.x = 128
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.show()
		else:
			$Input_Block_Container/Input_Menu_Container/Input_Container/Input.show()
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.custom_minimum_size.x = 72
			$Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.hide()
	get:
		return modify_ingredient_stock

func _on_accept_button_pressed():
	var input_text = $Input_Block_Container/Input_Menu_Container/Input_Container/Input.text
	var price_text = $Input_Block_Container/Input_Menu_Container/Input_Container/Product_Price.text
	var unit_text = $Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Unit.text
	var stock_text = $Input_Block_Container/Input_Menu_Container/Input_Container/Ingredient_Stock.text

	input_text = input_text.strip_edges(true,true)

	if product_menu:
		# Si es nombre y/o precio de producto
		if not input_text == "":
			input_text = input_text.to_lower()
			input_text = input_text.capitalize()
		else:
			input_text = ""

		if not price_text == "":
			price_text = price_text.strip_edges(true,true)
			price_text = price_text.replace(" ","")

			if price_text.is_valid_float():
				price_text = price_text.to_float()
			else:
				price_text = ""

		emit_signal("text_submit", price_text, input_text)
	elif product_menu_add_ingredient:
		# Si es nombre, unidad y/o stock de ingrediente
		if not input_text == "" and not unit_text == "" and stock_text.is_valid_int():
			input_text = input_text.to_lower()
			unit_text = unit_text.strip_edges(true,true)
			unit_text = unit_text.replace(" ","")
			stock_text = stock_text.strip_edges(true,true)
			stock_text = stock_text.replace(" ","")
		else:
			input_text = ""
			unit_text = ""
			stock_text = ""
		emit_signal("text_submit", unit_text, stock_text, input_text)
	elif modify_ingredient_stock:
		# Si es stock de ingrediente
		if not stock_text == "" and stock_text.is_valid_int():
			stock_text = stock_text.strip_edges(true,true)
			stock_text = stock_text.replace(" ","")
		else:
			stock_text = ""
		emit_signal("text_submit", "", stock_text, "")
	else:
		# Si es nombre de mesa
		input_text = input_text.replace(" ","")
		input_text = input_text.to_upper()
		if not input_text == "":
			emit_signal("text_submit", input_text)

	product_menu = false
	product_menu_add_ingredient = false
	self.queue_free()


func _on_exit_button_pressed():
	self.queue_free()
