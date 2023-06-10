extends Node2D

@onready var config_menu = $Main_Menu/Main_Menu_Config.get_popup()
@onready var system_datetime
@onready var users_scene = preload("res://scenes/users_menu_scene/users_menu_scene.tscn")
@onready var products_scene = preload("res://scenes/product_menu_scene/product_menu_scene.tscn")
@onready var billing_scene = preload("res://scenes/billing_menu_scene/billing_menu_scene.tscn")
const WEEKDAYS: Array = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]

func _ready():
	config_menu.connect("id_pressed", button_ID)
	$Seating_Scene.connect("tables_edited", _on_tables_edited)
	update_cutlery_count(43,51)


func _process(_delta):
	update_datetime_label()

#TODO: avisar cuando se entra en modo "edición de mesas" e impedir seleccionar mesas dentro de este modo


func update_datetime_label():
	system_datetime = Time.get_datetime_dict_from_system()
	$Info_Container/Date_Time_Label.set_text("%s %s/%s/%s, %s:%s hs" % [WEEKDAYS[system_datetime.weekday], system_datetime.day, system_datetime.month, system_datetime.year, system_datetime.hour, system_datetime.minute])


func update_cutlery_count(_open_cutlery: int, _closed_cutlery: int):
	$Info_Container/Open_Cutlery_Container/Open_Cutlery_Count.set_text("%s" % _open_cutlery)
	$Info_Container/Closed_Cutlery_Container/Closed_Cutlery_Count.set_text("%s" % _closed_cutlery)
	$Info_Container/Total_Cutlery_Container/Total_Cutlery_Count.set_text("%s" % (_open_cutlery + _closed_cutlery))

#Main_Menu_config.disabled al pedo!!! usar control node!!
#Side_Menu tiene que ser escena propia? hmm
func button_ID(id):
	if id == 0:
		$Main_Menu/Main_Menu_Config.disabled = true
		$Side_Menu.show()
	if id == 1:
		var users_screen = users_scene.instantiate()
		add_child(users_screen)
	if id == 2:
		var products_screen = products_scene.instantiate()
		add_child(products_screen)
	if id == 3:
		var billing_screen = billing_scene.instantiate()
		add_child(billing_screen)


func _on_exit_button_pressed():
	$Side_Menu.hide()
	$Main_Menu/Main_Menu_Config.disabled = false
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
