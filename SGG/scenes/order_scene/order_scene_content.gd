extends Control


signal order_sent(products, cutlery, waiter)


@onready var DB = EventBus.database
@onready var table_rows = $Block_Container/OrderSceneTable
@onready var total_amount = $Block_Container/Total_Amount_Label
@onready var selector_button: Button
@onready var is_add_mode: bool = true
@onready var is_deletable: bool = false
@onready var is_sent: bool = false
@onready var table: Object
@onready var products_in_order: Array = []


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	DB.connect("response_update_ingredient_stock_decrease", _on_response_update_ingredient_stock_decrease)
	DB.connect("response_update_ingredient_stock_increase", _on_response_update_ingredient_stock_increase)
	DB.connect("response_check_ingredient_stock", _on_response_check_ingredient_stock)
	table_rows.connect("response_selector_button", _on_response_selector_button)
	fill_waiter_list()
	fill_product_list()


func fill_order(_order: Array, _info: Array):
	for i in _order.size():
		products_in_order.append(_order[i]) # [cantidad, nombre, precio, is_sent = 0]
		products_in_order[i][3] = 1			# [cantidad, nombre, precio, is_sent = 1]
		table_rows.add_row_with_data(_order[i])
		calculate_total()
	$Block_Container/WaiterList.selected = _info[1]
	$Block_Container/WaiterList.disabled = true
	$Block_Container/Cutlery.value = _info[0]
	is_sent = true


func fill_waiter_list():
	for i in DatabaseContent.user_list.keys():
		if DatabaseContent.user_list[i].to_int() == 2:
			$Block_Container/WaiterList.add_item(i)
	$Block_Container/WaiterList.selected = -1


func fill_product_list():
	for i in DatabaseContent.product_list.keys():
		$Block_Container/ProductName.add_item(i)
	$Block_Container/ProductName.selected = -1


# Se ejecuta cuando se presiona el boton AddEdit
func _on_add_edit_pressed():
	if not $Block_Container/ProductName.selected == -1:
		# Se edita la fila seleccionada sin importar el modo
		var amount: String = $Block_Container/ProductAmount.get_line_edit().text
		var product: String = $Block_Container/ProductName.get_item_text($Block_Container/ProductName.selected)
		var price: String = str(DatabaseContent.product_list[product][0][0])
		table_rows.set_row_data(selector_button, amount, product, price)
		# Agregar (o no) una fila nueva
		if (is_add_mode):
			table_rows.duplicate_selector()
			table_rows.duplicate_row()
			$Block_Container/ProductName.set_item_disabled($Block_Container/ProductName.selected, true)
		$Block_Container/ProductAmount.editable = false
		$Block_Container/ProductName.disabled = true
		$Block_Container/AddEdit.disabled = true
		$Block_Container/Delete.disabled = true
		calculate_total()


func calculate_total() -> void:
	var valid_rows: Array = table_rows.get_valid_rows()
	var count: float = 0.0
	for i in range(2, valid_rows.size(), 3):
		count += (valid_rows[i-2].to_float() * valid_rows[i].to_float())
	total_amount.text = "%.2f" % count


# Se ejecuta cuando se presiona el boton Delete
func _on_delete_pressed():
	$Block_Container/ProductName.set_item_disabled($Block_Container/ProductName.selected, false)
	table_rows.delete_row(selector_button)
	calculate_total()


# Se ejecuta cuando se presiona el boton SendOrder
func _on_send_order_pressed():
	if not $Block_Container/WaiterList.selected == -1:
		var selected_order = table_rows.get_valid_rows() # [cantidad, nombre, precio, cantidad, nombre, precio, cantidad, nombre, precio, cantidad, nombre, precio]
		if not selected_order.is_empty():
			var _debug = 0
			var b: int = 0
			var n: int = 0
			if products_in_order.is_empty():
				n = selected_order.size() / 3
			else:
				b = products_in_order.size()
				n = selected_order.size() / 3
				# No enviar pedido si no agregamos nada nuevo
				if (b == n):
					return
			for i in range(b, n):
				var selected_order_item = selected_order.slice(i*3,i*3+3)
				selected_order_item.append(0) # [cantidad, nombre, precio, is_sent = 0]
				products_in_order.append(selected_order_item) # [[cantidad, nombre, precio, is_sent = 0], [cantidad, nombre, precio, is_sent = 0]]
			var cutlery = $Block_Container/Cutlery.get_line_edit().text.to_int()
			var waiter = $Block_Container/WaiterList.get_selected()
			for i in (products_in_order.size()):
				if products_in_order[i][3] == 0:
					DB.update_ingredient_stock_decrease(products_in_order[i][1], products_in_order[i][0])
					await DB.httpr.request_completed
			is_sent = true
			emit_signal("order_sent", products_in_order, cutlery, waiter)
			#EventBus.emit_signal("update_cutlery", $Block_Container/Cutlery.get_line_edit().text.to_int(), "open")
		else:
			table.table_texture_change("TABLE_FREE")
		self.queue_free()


# Se ejecuta cuando se presiona el boton CancelOrder
func _on_cancel_order_pressed():
	var selected_order = table_rows.get_valid_rows()
	if selected_order != [] and is_sent:
		table.table_texture_change("TABLE_OCCUPIED")
	else:
		table.table_texture_change("TABLE_FREE")
	self.queue_free()


# Se ejecuta cuando Table envia su señal de response_selector_button
func _on_response_selector_button(selector_button_pressed):
	$Block_Container/ProductName.disabled = false
	selector_button = selector_button_pressed
	var row_data: Dictionary = table_rows.get_row_data(selector_button_pressed)
	if (row_data.get("Amount") == "" && row_data.get("Product") == "" && row_data.get("Price") == ""):
		is_add_mode = true
		is_deletable = false
		$Block_Container/ProductAmount.value = 1
		$Block_Container/ProductName.selected = -1
		$Block_Container/Delete.disabled = true
	else:
		is_add_mode = false
		is_deletable = true
		$Block_Container/ProductAmount.value = (int)(row_data["Amount"])
		$Block_Container/ProductName.selected = find_item_index($Block_Container/ProductName, row_data["Product"])
		$Block_Container/ProductName.set_item_disabled($Block_Container/ProductName.selected, true)
		$Block_Container/ProductName.disabled = true
		$Block_Container/ProductAmount.editable = true
		$Block_Container/AddEdit.disabled = false
		$Block_Container/Delete.disabled = false


# Buscar en el OptionButton el texto ingresado y devolver en que posicion se encuentra
func find_item_index(option_button: OptionButton, text: String) -> int:
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == text:
			return i
	return -1


func selected_table(_table: Object):
	table = _table


# Se ejecuta cuando se presiona el boton Close_Table
func _on_close_table_pressed():
	table.table_texture_change("TABLE_FREE")

	# TODO

	self.queue_free()


# Se ejecuta cuando Database envia su señal de response_update_ingredient_stock_decrease
func _on_response_update_ingredient_stock_decrease(_update_successfully: String) -> void:
	var error_label = $Block_Container/Error_Label
	if (_update_successfully.to_int() == 1):
		error_label.visible = false
	else:
		error_label.visible = true
		error_label.text = "ERROR\nNo se pudo descontar el stock"


# Se ejecuta cuando Database envia su señal de response_update_ingredient_stock_increase
func _on_response_update_ingredient_stock_increase(_update_successfully: String) -> void:
	print("[INFO] Stock restaurado")


# Se ejecuta cuando Database envia su señal de response_check_ingredient_stock
func _on_response_check_ingredient_stock(_update_successfully: String) -> void:
	var error_label = $Block_Container/Error_Label
	if (_update_successfully.to_int() == 1):
		$Block_Container/AddEdit.disabled = false
		error_label.visible = false
	else:
		$Block_Container/AddEdit.disabled = true
		error_label.visible = true
		error_label.text = "ERROR\nNo hay stock suficiente"


# Se ejecuta cuando se presiona selecciona un item de ProductName
func _on_product_name_item_selected(_index):
	DB.check_ingredient_stock($Block_Container/ProductName.get_item_text(_index), 1)
	await DB.httpr.request_completed
	$Block_Container/ProductAmount.value = 1
	$Block_Container/ProductAmount.editable = true


# Se ejecuta cuando cambia el valor del ProductAmount
func _on_product_amount_value_changed(_value):
	$Block_Container/AddEdit.disabled = true
	# La comprobación de stock se hace en _on_timer_timeout()
	$Block_Container/ProductAmount/Timer.start(0.125)
	await $Block_Container/ProductAmount/Timer.timeout


# Se ejecuta cuando se llama a _on_product_amount_value_changed()
# Evita que se pueda spamear la señal y rompa todo
func _on_timer_timeout():
	# Realiza la comprobación de stock aquí
	var product_name = $Block_Container/ProductName.get_item_text($Block_Container/ProductName.selected)
	var value = $Block_Container/ProductAmount.value
	DB.check_ingredient_stock(product_name, value)
	await DB.httpr.request_completed
