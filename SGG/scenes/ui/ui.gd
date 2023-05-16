extends Node2D

@onready var config_menu = $Main_Menu/Main_Menu_Config.get_popup()

func _ready():
	config_menu.connect("id_pressed", button_ID)
	$Seating_Scene.tables_edited.connect(_on_tables_edited)

#TODO: avisar cuando se entra en modo "edición de mesas" e impedir seleccionar mesas dentro de este modo
# AUTOLOAD SIGNAL BUS!!!!!!

func button_ID(id):
	if id == 0:
		toggle_node_visibility($Side_Menu)
		toggle_node_visibility($Seating_Scene)

func toggle_node_visibility(node: Node):
	if not node.is_visible():
		node.show()
	else:
		node.hide()

func _on_exit_button_pressed():
	toggle_node_visibility($Side_Menu)

func _on_add_table_toggled(button_pressed):
	if button_pressed:
		$Seating_Scene/Seating_Area/Seating_Area_Background.show()
		$Seating_Scene.table_add_mode = true;
	else:
		$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
		$Seating_Scene.table_add_mode = false;

func _on_remove_table_toggled(button_pressed):
	if button_pressed:
		$Seating_Scene/Seating_Area/Seating_Area_Background.show()
		$Seating_Scene.table_remove_mode = true;
	else:
		$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
		$Seating_Scene.table_remove_mode = false;

func _on_tables_edited():
	$Side_Menu/Add_Table.set_pressed(false)
	$Side_Menu/Remove_Table.set_pressed(false)
