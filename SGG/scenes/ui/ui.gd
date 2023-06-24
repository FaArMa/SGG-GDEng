extends Node2D

@onready var config_menu = $Main_Menu/Main_Menu_Config.get_popup()
@onready var open_cutlery = $Info_Container/Open_Cutlery_Container/Open_Cutlery_Count
@onready var closed_cutlery = $Info_Container/Closed_Cutlery_Container/Closed_Cutlery_Count
@onready var total_cutlery = $Info_Container/Total_Cutlery_Container/Total_Cutlery_Count
@onready var system_datetime
@onready var users_scene = preload("res://scenes/users_menu_scene/users_menu_scene.tscn")
@onready var products_scene = preload("res://scenes/product_menu_scene/product_menu_scene.tscn")
@onready var billing_scene = preload("res://scenes/billing_menu_scene/billing_menu_scene.tscn")
@onready var login_scene = preload("res://scenes/login_screen/login_screen.tscn")
const WEEKDAYS: Array = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]

var user_role: int = -1

func _ready():
	#EventBus.connect("update_cutlery", _on_update_cutlery)
	config_menu.connect("id_pressed", button_ID)
	$Seating_Scene.connect("tables_edited", _on_tables_edited)


func _process(_delta):
	update_datetime_label()


func update_datetime_label():
	system_datetime = Time.get_datetime_dict_from_system()
	$Info_Container/Date_Time_Label.set_text("%s %s/%s/%s, %s:%s hs" % [WEEKDAYS[system_datetime.weekday], system_datetime.day, system_datetime.month, system_datetime.year, system_datetime.hour, system_datetime.minute])


func _on_update_cutlery(quantity, type):
	if type == "open":
		open_cutlery.set_text("%d" % (quantity + open_cutlery.text.to_int()))
	elif type == "closed":
		closed_cutlery.set_text("%d" % quantity.to_int() + open_cutlery.text.to_int())
	total_cutlery.set_text("%d" % (open_cutlery.text.to_int() + closed_cutlery.text.to_int()))

#Main_Menu_config.disabled al pedo!!! usar control node!!
#Side_Menu tiene que ser escena propia? hmm
func button_ID(id):
	var login = login_scene.instantiate()
	EventBus.is_popup_login = true
	add_child(login)

	match id:
		0:
			login.connect("role_checked", _on_role_check.bind(0))

			await login.role_checked

			if user_role == 0:
				EventBus.table_edit_mode = true
				$Main_Menu/Main_Menu_Config.disabled = true
				$Side_Menu.show()
		1:
			login.connect("role_checked", _on_role_check.bind(0))

			await login.role_checked

			if user_role == 0:
				var users_screen = users_scene.instantiate()
				add_child(users_screen)
		2:
			login.connect("role_checked", _on_role_check.bind(1))

			await login.role_checked

			if user_role == 1:
				var products_screen = products_scene.instantiate()
				add_child(products_screen)
		3:
			login.connect("role_checked", _on_role_check.bind(3))

			await login.role_checked

			if user_role == 3:
				var billing_screen = billing_scene.instantiate()
				add_child(billing_screen)

	user_role = -1


func _on_role_check(username, required_role):
	var inquiring_role = DatabaseContent.user_list[username].to_int()
	if inquiring_role == required_role or inquiring_role == 0:
		user_role = required_role
	else:
		print("No tiene los permisos necesarios para acceder.")


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
	EventBus.table_edit_mode = false


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
		EventBus.table_edit_mode = false
	else:
		$Seating_Scene/Seating_Area/Seating_Area_Background.hide()
		$Seating_Scene.table_remove_mode = false;
		EventBus.table_edit_mode = false


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
