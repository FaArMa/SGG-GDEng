extends Control

signal order_sent(products, cutlery, waiter)

@onready var table_rows = $Block_Container/OrderSceneTable
@onready var total_amount = $Block_Container/Total_Amount_Label
@onready var selector_button: Button
@onready var is_add_mode: bool = true
@onready var is_deletable: bool = false


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	table_rows.connect("response_selector_button", _on_response_selector_button)
	fill_waiter_list()
	fill_product_list()


func fill_order(_order: Array, _info: Array):
	for i in _order.size():
		table_rows.add_row_with_data(_order[i])
		calculate_total()
	$Block_Container/WaiterList.selected = _info[1]
	$Block_Container/Cutlery.value = _info[0]


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
		# TODO Obtener el price de dicho product con Database o lo que corresponda
		var price: String = str(DatabaseContent.product_list[product][0][0])
		table_rows.set_row_data(selector_button, amount, product, price)
		# Agregar (o no) una fila nueva
		if (is_add_mode):
			table_rows.duplicate_selector()
			table_rows.duplicate_row()
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
	table_rows.delete_row(selector_button)
	calculate_total()


# Se ejecuta cuando se presiona el boton SendOrder
func _on_send_order_pressed():
	if not $Block_Container/WaiterList.selected == -1:
		var selected_order = table_rows.get_valid_rows()
		if not selected_order.is_empty():
			var products_in_order: Array = []
			for i in (selected_order.size() / 3):
				products_in_order.append(selected_order.slice(i*3,i*3+3))
			var cutlery = $Block_Container/Cutlery.get_line_edit().text.to_int()
			var waiter = $Block_Container/WaiterList.get_selected()
			emit_signal("order_sent", products_in_order, cutlery, waiter)
			#EventBus.emit_signal("update_cutlery", $Block_Container/Cutlery.get_line_edit().text.to_int(), "open")
		self.queue_free()


# Se ejecuta cuando se presiona el boton CancelOrder
func _on_cancel_order_pressed():
	self.queue_free()


# Se ejecuta cuando Table envia su señal de response_selector_button
func _on_response_selector_button(selector_button_pressed):
	$Block_Container/ProductAmount.editable = true
	$Block_Container/ProductName.disabled = false
	$Block_Container/AddEdit.disabled = false
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
		$Block_Container/Delete.disabled = false


# Buscar en el OptionButton el texto ingresado y devolver en que posicion se encuentra
func find_item_index(option_button: OptionButton, text: String) -> int:
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == text:
			return i
	return -1


func _on_close_table_pressed():
	pass # Replace with function body.
