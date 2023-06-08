extends Control


@onready var table_rows = $OrderSceneTable
@onready var selector_button: Button
@onready var is_add_mode: bool = true
@onready var is_deletable: bool = false


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	table_rows.connect("response_selector_button", _on_response_selector_button)


# Se ejecuta cuando se presiona el boton AddEdit
func _on_add_edit_pressed():
	# Se edita la fila seleccionada sin importar el modo
	var amount: String = $ProductAmount.get_line_edit().text
	var product: String = $ProductName.get_item_text($ProductName.selected)
	# TODO Obtener el price de dicho product con Database o lo que corresponda
	var price: String = "123.45"
	table_rows.set_row_data(selector_button, amount, product, price)
	# Agregar (o no) una fila nueva
	if (is_add_mode):
		table_rows.duplicate_selector()
		table_rows.duplicate_row()
	$ProductAmount.editable = false
	$ProductName.disabled = true
	$AddEdit.disabled = true
	$Delete.disabled = true
	$SendOrder.disabled = true
	$CancelOrder.disabled = true


# Se ejecuta cuando se presiona el boton Delete
func _on_delete_pressed():
	table_rows.delete_row(selector_button)


# Se ejecuta cuando se presiona el boton SendOrder
func _on_send_order_pressed():
	pass


# Se ejecuta cuando se presiona el boton CancelOrder
func _on_cancel_order_pressed():
	pass


# Se ejecuta cuando Table envia su señal de response_selector_button
func _on_response_selector_button(selector_button_pressed):
	$ProductAmount.editable = true
	$ProductName.disabled = false
	$AddEdit.disabled = false
	$SendOrder.disabled = false
	$CancelOrder.disabled = false
	selector_button = selector_button_pressed
	var row_data: Dictionary = table_rows.get_row_data(selector_button_pressed)
	if (row_data.get("Amount") == "" && row_data.get("Product") == "" && row_data.get("Price") == ""):
		is_add_mode = true
		is_deletable = false
		$ProductAmount.value = 1
		$ProductName.selected = -1
		$Delete.disabled = true
	else:
		is_add_mode = false
		is_deletable = true
		$ProductAmount.value = (int)(row_data["Amount"])
		$ProductName.selected = find_item_index($ProductName, row_data["Product"])
		$Delete.disabled = false


# Buscar en el OptionButton el texto ingresado y devolver en que posicion se encuentra
func find_item_index(option_button: OptionButton, text: String) -> int:
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == text:
			return i
	return -1
