extends Node2D

@onready var table_scene = preload("res://scenes/mesa/table_scene.tscn")
@onready var single_line_input = preload("res://scenes/Single_Line_Input_Scene/single_line_input.tscn")
@onready var tables: Dictionary = {}
@onready var table_add_mode: bool = false
@onready var table_remove_mode: bool = false

signal tables_edited

func _on_seating_area_input_event(_viewport, event, _shape_idx):
	if table_add_mode:
		if event.is_action_pressed("left_click"):
			var input = single_line_input.instantiate()
			input.text_submit.connect(_on_single_line_input_submit.bind(event.position))
			input.text_discard.connect(_on_single_line_input_discard)
			add_child(input)

func _on_single_line_input_submit(text_input: String, pos: Vector2):
	var repeated_table_name = false
	if tables.is_empty():
		add_table_to_seating_area(text_input, pos)
	else:
		for i in tables.values():
			print(i[0], ", ", i[1], "text_input: ", text_input)
			if i[0] == text_input:
				repeated_table_name = true
	if repeated_table_name:
		print("Mesa ", text_input, " repetida. Inténtelo nuevamente.")
	else:
		add_table_to_seating_area(text_input, pos)
	emit_signal("tables_edited")
	
	
func _on_single_line_input_discard():
	pass

func add_table_to_seating_area(text_input: String, pos: Vector2):
	var new_table = table_scene.instantiate()
	new_table.position = pos
	new_table.table_name = text_input
	new_table.table_clicked.connect(_on_remove_table_from_seating_area)
	add_child(new_table)
	tables[new_table] = [new_table.table_name, new_table.position]
	print("added ", tables)

func _on_remove_table_from_seating_area(table: Object):
	if table_remove_mode:
		for i in tables.keys():
			if i == table:
				tables.erase(table)
				table.delete_table(table)
		remove_child(table)
		emit_signal("tables_edited")
		print("removed ", tables)
