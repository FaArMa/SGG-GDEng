extends Node2D

@onready var config_menu = $Main_Menu/Main_Menu_Config.get_popup()

func _ready():
	config_menu.connect("id_pressed", button_ID)
	$Seating_Scene.connect("tables_edited", _on_tables_edited)

#TODO: avisar cuando se entra en modo "edición de mesas" e impedir seleccionar mesas dentro de este modo


func button_ID(id):
	if id == 0:
		$Side_Menu.show()


func _on_exit_button_pressed():
	$Side_Menu.hide()
	$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
	$Seating_Scene/Table_Ghost.hide()
	$Side_Menu/Add_Table.set_pressed(false)
	$Side_Menu/Remove_Table.set_pressed(false)
	$Side_Menu/Modify_Wall.set_pressed(false)
	$Seating_Scene.wall_edit_mode = false;
	$Seating_Scene.table_add_mode = false;
	$Seating_Scene.table_remove_mode = false;


func _on_add_table_toggled(button_pressed):
	if button_pressed:
		$Seating_Scene/Seating_Area/Seating_Area_Background.show()
		$Seating_Scene/Table_Ghost.show()
		$Seating_Scene.table_add_mode = true;
	else:
		$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
		$Seating_Scene/Table_Ghost.hide()
		$Seating_Scene.table_add_mode = false;


func _on_remove_table_toggled(button_pressed):
	if button_pressed:
		$Seating_Scene/Seating_Area/Seating_Area_Background.show()
		$Seating_Scene/Table_Ghost.hide()
		$Seating_Scene.table_remove_mode = true;
	else:
		$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
		$Seating_Scene.table_remove_mode = false;


func _on_modify_wall_toggled(button_pressed):
	if button_pressed:
		$Seating_Scene/Seating_Area/Seating_Area_Background.show()
		$Seating_Scene/Table_Ghost.show()
		$Seating_Scene.wall_edit_mode = true;
	else:
		$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
		$Seating_Scene/Table_Ghost.hide()
		$Seating_Scene.wall_edit_mode = false;


func _on_tables_edited():
	$Side_Menu/Add_Table.set_pressed(false)
	$Side_Menu/Remove_Table.set_pressed(false)
