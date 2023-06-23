extends Node2D

const TABLE_FREE = preload("res://scenes/mesa/mesa_libre.png")
const TABLE_SELECTED = preload("res://scenes/mesa/mesa_seleccionada.png")
const TABLE_OCCUPIED = preload("res://scenes/mesa/mesa_ocupada.png")

signal table_clicked(table)

var table_name: String:
	set(value):
		table_name = value
	get:
		return table_name

var table_position: Vector2:
	set(value):
		table_position = value
	get:
		return table_position

func _ready():
	$Table_Text.text = table_name

func table_texture_change(state):
	match state:
		"TABLE_FREE":
			$Table_Icon.texture = TABLE_FREE
		"TABLE_SELECTED":
			$Table_Icon.texture = TABLE_SELECTED
		"TABLE_OCCUPIED":
			$Table_Icon.texture = TABLE_OCCUPIED

func _on_area_mesa_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		if not EventBus.table_edit_mode:
			table_texture_change("TABLE_SELECTED")
			emit_signal("table_clicked", self)

func delete_table(_table: Object):
	_table.queue_free()
