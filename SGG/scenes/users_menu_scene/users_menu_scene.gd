extends Control

@onready var selected_user: String = ""
@onready var current_users: Dictionary = {}
@onready var register_scene = preload("res://scenes/register_screen/register_screen.tscn")


func _ready():
	current_users = DatabaseContent.user_list
	load_user_list()


func load_user_list():
	$Content_Container/User_List.clear()

	if not current_users.is_empty():
		for i in current_users.keys():
			$Content_Container/User_List.add_item(i, null, true)


func _on_register_user_button_pressed():
	var register = register_scene.instantiate()
	register.connect("register_screen_return", _on_register_screen_return.bind(register))
	add_child(register)


func _on_register_screen_return(_instance):
	remove_child(_instance)


func _on_erase_user_button_pressed():
	$Confirm_Dialog.show()


func _on_cancel_button_pressed():
	$Confirm_Dialog.hide()
	$Content_Container/User_List.deselect_all()


func _on_accept_button_pressed():
#	Confirmación
#		Sí
#			DB.erase_user(selected_user)
#			O mejor una señal global??
#		No
#			...
	$Confirm_Dialog.hide()


func _on_modify_user_button_pressed():
#	Ventana Popup (nueva escena "modify_users_scene")
#	Desde la nueva escena:
#		DB.modify_user(selected_user)
#		O mejor una señal global??
	pass


func _on_user_list_item_selected(index):
	var permission_labels = get_tree().get_nodes_in_group("permissions")
	var permissions_array: Array = []

	selected_user = $Content_Container/User_List.get_item_text(index)
	$Content_Container/User_Permissions_Button_Container/Erase_User_Button.disabled = false
	$Content_Container/User_Permissions_Button_Container/Modify_User_Button.disabled = false


	match current_users[selected_user]:
		"0":
			permissions_array = [1,1,1,1,1,1]
		"1":
			permissions_array = [0,0,0,1,1,1]
		"2":
			permissions_array = [0,0,0,0,0,1]
		"3":
			permissions_array = [0,0,1,0,0,0]
		_:
			print("%s, wtf?" % current_users[selected_user])

	for i in permissions_array.size():
		if permissions_array[i] == 0:
			permission_labels[i].hide()
		else:
			permission_labels[i].show()


func _on_exit_button_pressed():
	self.queue_free()

