extends Control

var parent_scene

func _ready():
	var system_datetime = Time.get_datetime_dict_from_system()
	$Block_Container/HBoxContainer/Ticket_Detail/Date_Label.text = "Fecha: %02d/%02d/%d" % [system_datetime.day, system_datetime.month, system_datetime.year]
	$Block_Container/HBoxContainer/Ticket_Detail/Time_Label.text = "Hora: %02d:%02d" % [system_datetime.hour, system_datetime.minute]


func _on_exit_button_pressed():
	parent_scene.queue_free()


func fill_ticket(table, waiter, total, order, ticket_id):	
	$Block_Container/HBoxContainer/Ticket_Detail/Table_Label.text = table
	$Block_Container/HBoxContainer/Ticket_Detail/Waiter_Label.text = waiter
	$Block_Container/HBoxContainer/Ticket_Detail/Total_Label.text = str("%.2f" % total)
	$Block_Container/HBoxContainer/Ticket_Detail/Ticket_ID_Label.text = "N° Ticket: %010d" % ticket_id.to_int()
	for i in order.size():
		$Block_Container/HBoxContainer/Ticket_Detail/Purchased_Item_List.add_item(order[i][1])
		$Block_Container/HBoxContainer/Ticket_Detail/Purchased_Item_List.add_item(order[i][0])
		$Block_Container/HBoxContainer/Ticket_Detail/Purchased_Item_List.add_item(str(order[i][2].to_float() * order[i][0].to_float()))
		

func assign_parent(parent):
	parent_scene = parent
