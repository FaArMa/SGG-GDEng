extends Control


signal response_selector_button(selector_button)


@onready var previous_selector_button = null


# Se ejecuta cuando el nodo entra en el árbol de escena por primera vez
func _ready():
	var selector_button = $ScrollContainer/Control/GridSelector/SelectorButton0
	selector_button.connect("pressed", _on_selector_button_pressed.bind(selector_button))
	duplicate_selector()
	duplicate_row()


# Se ejecuta cuando se presiona el boton SelectorButton#
func _on_selector_button_pressed(selector_button_pressed):
	if previous_selector_button:
		previous_selector_button.disabled = false
	selector_button_pressed.disabled = true
	previous_selector_button = selector_button_pressed
	emit_signal("response_selector_button", selector_button_pressed)


# Duplicar el selector de la fila (SelectorButton0)
func duplicate_selector() -> void:
	var grid_selector = $ScrollContainer/Control/GridSelector
	var selector_button = $ScrollContainer/Control/GridSelector/SelectorButton0
	var selector_button_duplicate = selector_button.duplicate()
	var total_selector_button = grid_selector.get_child_count()
	selector_button_duplicate.name = "SelectorButton%s" % total_selector_button
	selector_button_duplicate.connect("pressed", _on_selector_button_pressed.bind(selector_button_duplicate))
	selector_button_duplicate.visible = true
	grid_selector.add_child(selector_button_duplicate)
	return


# Duplicar la fila (AmountLabel0, ProductLabel0, PriceLabel0)
func duplicate_row() -> void:
	var grid_row = $ScrollContainer/Control/GridRow
	var amount_label = $ScrollContainer/Control/GridRow/AmountLabel0
	var product_label = $ScrollContainer/Control/GridRow/ProductLabel0
	var price_label = $ScrollContainer/Control/GridRow/PriceLabel0
	# Obtengo la cantidad de filas
	@warning_ignore("INTEGER_DIVISION")
	var total_row = (grid_row.get_child_count() / 3)
	# Duplico cada celda de la fila
	var amount_label_duplicate = amount_label.duplicate()
	var product_label_duplicate = product_label.duplicate()
	var price_label_duplicate = price_label.duplicate()
	# Le cambio el nombre a cada celda duplicada
	amount_label_duplicate.name = "AmountLabel%s" % total_row
	product_label_duplicate.name = "ProductLabel%s" % total_row
	price_label_duplicate.name = "PriceLabel%s" % total_row
	# Vuelvo visible cada celda
	amount_label_duplicate.visible = true
	product_label_duplicate.visible = true
	price_label_duplicate.visible = true
	# Agrego cada celda al final del GridRow
	grid_row.add_child(amount_label_duplicate)
	grid_row.add_child(product_label_duplicate)
	grid_row.add_child(price_label_duplicate)
	return


# Obtener un Diccionario con los Label correspondientes al SelectorButton#
func get_label_list(selector_button_pressed) -> Dictionary:
	var grid_row = $ScrollContainer/Control/GridRow
	var selector_button_name = selector_button_pressed.name
	var label_nodes: Dictionary = {}
	# Obtener los Labels
	label_nodes["AmountLabel"] = get_label(grid_row, selector_button_name, "AmountLabel")
	label_nodes["ProductLabel"] = get_label(grid_row, selector_button_name, "ProductLabel")
	label_nodes["PriceLabel"] = get_label(grid_row, selector_button_name, "PriceLabel")
	return label_nodes


# Obtener el Label correspondiente al SelectorButton#
# La función se hizo para que no sea un dolor leer la función get_label_list()
func get_label(grid_row, selector_button_name, label_type) -> Label:
	var label_text = selector_button_name.replace("SelectorButton", label_type)
	return grid_row.find_child(label_text, true, false)


# Obtener los valores de cada celda de la fila seleccionada
func get_row_data(selector_button_pressed) -> Dictionary:
	var label_nodes = get_label_list(selector_button_pressed)
	var row: Dictionary = {
		"Amount": label_nodes["AmountLabel"].text,
		"Product": label_nodes["ProductLabel"].text,
		"Price": label_nodes["PriceLabel"].text
	}
	return row


# Colocar los valores en cada celda de la fila seleccionada
func set_row_data(selector_button_pressed, amount, product, price) -> void:
	var label_nodes = get_label_list(selector_button_pressed)
	label_nodes["AmountLabel"].text = amount
	label_nodes["ProductLabel"].text = product
	label_nodes["PriceLabel"].text = price
	selector_button_pressed.disabled = false
	return


# Eliminar toda la fila seleccionada
func delete_row(selector_button_pressed) -> void:
	var label_nodes = get_label_list(selector_button_pressed)
	selector_button_pressed.queue_free()
	label_nodes["AmountLabel"].queue_free()
	label_nodes["ProductLabel"].queue_free()
	label_nodes["PriceLabel"].queue_free()
	previous_selector_button = null
	return
