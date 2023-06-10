extends Control

@onready var start_date = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/Start_Date
@onready var end_date = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/End_Date

func _on_cancel_button_pressed():
	self.queue_free()


func _on_accept_button_pressed():
#	DB.billing_search(start_date.text, end_date.text)
	pass
