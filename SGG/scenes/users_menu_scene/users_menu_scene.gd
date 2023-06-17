extends Control

@onready var selected_user: String = ""
@onready var current_users: Dictionary = {}
@onready var register_scene = preload("res://scenes/register_screen/register_screen.tscn")
@onready var permission_labels = get_tree().get_nodes_in_group("permissions")


func _ready():
	EventBus.connect("user_list_updated", _on_users_updated)
	load_user_list()


func _on_users_updated():
	load_user_list()


func load_user_list():
	$Content_Container/User_List.clear()

	current_users = DatabaseContent.user_list

	if not current_users.is_empty():
		for i in current_users.keys():
			$Content_Container/User_List.add_item(i, null, true)


func _on_register_user_button_pressed():
	var register = register_scene.instantiate()
	register.connect("register_screen_return", _on_register_screen_return.bind(register))
	add_child(register)


func _on_register_screen_return(_instance):
	load_user_list()
	_instance.modify_user_mode = false
	remove_child(_instance)
	hide_deselect_ui()


func _on_erase_user_button_pressed():
	$Confirm_Dialog.show()



func _on_cancel_button_pressed():
	$Confirm_Dialog.hide()
	hide_deselect_ui()


func _on_accept_button_pressed():
	var DB = EventBus.database

	DB.delete_user(selected_user)
	await DB.httpr.request_completed
	DB.get_user_list()

	$Confirm_Dialog.hide()
	hide_deselect_ui()


func _on_modify_user_button_pressed():
	var DB = EventBus.database
	var register = register_scene.instantiate()

	register.connect("register_screen_return", _on_register_screen_return.bind(register))

	add_child(register)
	register.modify_user_mode = true

	await DB.httpr.request_completed
	DB.get_user_info(selected_user)
	await DB.httpr.request_completed

	register.autocomplete_user_info(selected_user)

	hide_deselect_ui()


func _on_user_list_item_selected(index):
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


func hide_deselect_ui():
	$Content_Container/User_List.deselect_all()
	$Content_Container/User_Permissions_Button_Container/Erase_User_Button.disabled = true
	$Content_Container/User_Permissions_Button_Container/Modify_User_Button.disabled = true

	for i in permission_labels:
		i.hide()
