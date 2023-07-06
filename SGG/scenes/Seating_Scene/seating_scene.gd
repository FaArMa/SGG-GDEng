extends Node2D

signal tables_edited

@onready var table_scene = preload("res://scenes/mesa/table_scene.tscn")
@onready var wall_scene = preload("res://scenes/wall_scene/wall_scene.tscn")
@onready var single_line_input = preload("res://scenes/Single_Line_Input_Scene/single_line_input.tscn")
@onready var order_scene = preload("res://scenes/order_scene/order_scene_content.tscn")
@onready var print_order_scene = preload("res://scenes/printable_order/printable_order.tscn")
@onready var tables: Dictionary = {}
@onready var walls: Array = []
@onready var table_add_mode: bool = false
@onready var table_remove_mode: bool = false
@onready var wall_edit_mode: bool = false
@onready var wall_just_deleted: bool = false
@onready var loading: bool = false
@onready var orders: Dictionary = {}
@onready var extra_table_info: Dictionary = {}
#{
#	nombre_mesa: [[cantidad, producto, precio], [cantidad, producto, precio]]
#}

func _ready():
	load_objects()


func _on_seating_area_input_event(_viewport, event, _shape_idx):
	if table_add_mode:
		$Table_Ghost.set_position(snap_position(event.position))
		if event.is_action_pressed("left_click"):
			$Table_Ghost.set_position(snap_position(event.position))
			var input = single_line_input.instantiate()
			input.connect("text_submit", _on_single_line_input_submit.bind(snap_position(event.position)))
			add_child(input)
	if wall_edit_mode:
		if !wall_just_deleted:
			$Table_Ghost.set_position(snap_position(event.position))
			if event.is_action_pressed("left_click"):
				edit_walls_on_seating_area(snap_position(event.position))
		wall_just_deleted = false


func _on_single_line_input_submit(text_input: String, pos: Vector2):
	if is_position_valid(pos) and is_name_valid(text_input):
		add_table_to_seating_area(text_input, pos)


func is_name_valid(text_input: String) -> bool:
	for i in tables.values():
		if i[0] == text_input:
			print("- Nombre de mesa inválido -")
			return false
	return true


func is_position_valid(pos: Vector2) -> bool:
	for i in walls.size():
		if walls[i].wall_position == pos:
			print("- Posición inválida -")
			return false
	for k in tables.values():
		if k[1] == pos:
			print("- Posición inválida -")
			return false
	return true


func add_table_to_seating_area(text_input: String, pos: Vector2):
	var new_table = table_scene.instantiate()

	new_table.position = pos
	new_table.table_position = pos
	new_table.table_name = text_input
	new_table.connect("table_clicked", _on_table_clicked)
	tables[new_table] = [new_table.table_name, new_table.table_position]
	add_child(new_table)

	if !loading:
		save_objects()
		emit_signal("tables_edited")

	#print("- Added ", tables)


func edit_walls_on_seating_area(pos: Vector2):
	if is_position_valid(pos):
		add_wall_to_seating_area(pos)


func add_wall_to_seating_area(pos: Vector2):
	var new_wall = wall_scene.instantiate()

	new_wall.wall_position = pos
	new_wall.position = pos
	new_wall.connect("wall_clicked", _on_remove_wall_from_seating_area)
	walls.append(new_wall)
	add_child(new_wall)

	if !loading: save_objects()


func _on_table_clicked(_table: Object):
	if table_remove_mode:
		tables.erase(_table)
		_table.delete_table(_table)
		remove_child(_table)
		save_objects()
		print("- Removed ", tables)
		emit_signal("tables_edited")
	else:
		var order_screen = order_scene.instantiate()
		add_child(order_screen)
		order_screen.selected_table(_table)
		if orders.has(_table.table_name):
			order_screen.fill_order(orders[_table.table_name], extra_table_info[_table.table_name])
		order_screen.connect("order_sent", _on_order_sent.bind(_table))


func _on_order_sent(_products: Array, _cutlery: int, _waiter: int, _table: Object):
	orders[_table.table_name] = _products
	extra_table_info[_table.table_name] = [_cutlery, _waiter]

	_table.table_texture_change("TABLE_OCCUPIED")

	var printable_order = print_order_scene.instantiate()

	for i in _products.size():
		if DatabaseContent.product_list[_products[i][1]][0][1] == "comida":
			printable_order.get_node("Block_Container/HBoxContainer/Food_Order/Food_Order_List").add_item(_products[i][0])
			printable_order.get_node("Block_Container/HBoxContainer/Food_Order/Food_Order_List").add_item(_products[i][1])
		elif DatabaseContent.product_list[_products[i][1]][0][1] == "bebida":
			printable_order.get_node("Block_Container/HBoxContainer/Drink_Order/Drink_Order_List").add_item(_products[i][0])
			printable_order.get_node("Block_Container/HBoxContainer/Drink_Order/Drink_Order_List").add_item(_products[i][1])
	if printable_order.get_node("Block_Container/HBoxContainer/Food_Order/Food_Order_List").get_item_count() == 0:
		printable_order.get_node("Block_Container/HBoxContainer/Food_Order").hide()
	if printable_order.get_node("Block_Container/HBoxContainer/Drink_Order/Drink_Order_List").get_item_count() == 0:
		printable_order.get_node("Block_Container/HBoxContainer/Drink_Order").hide()
	add_child(printable_order)


func _on_remove_wall_from_seating_area(_wall: Object):
	if wall_edit_mode:
		walls.erase(_wall)
		_wall.delete_wall(_wall)
		remove_child(_wall)
		save_objects()
		wall_just_deleted = true
		print("- Pared Eliminada -")


func snap_position(pos: Vector2) -> Vector2:
	var snap_x = snapped(pos.x, 48)
	var snap_y = snapped(pos.y, 48)
	var snap := Vector2(snap_x, snap_y)
	return snap


func save_objects():
	var objects = SessionSave.new()

	objects.save_state(tables, walls)


func load_objects():
	loading = true

	var objects = SessionSave.new()
	var loaded_objects: Array

	loaded_objects = objects.load_state(tables, walls)

	for i in loaded_objects[0].values():
		add_table_to_seating_area(i[0], i[1])

	for i in loaded_objects[1].size():
		add_wall_to_seating_area(loaded_objects[1][i].wall_position)

	loading = false
