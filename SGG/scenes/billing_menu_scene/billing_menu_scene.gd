extends Control

@onready var Search_Dialog = $Billing_Menu_Container/Search_Result_Container
@onready var Search_Items = $Billing_Menu_Container/Search_Result_Container/Search_Result_Content_Container/Search_Container/Search_Items
@onready var Search_Summary = $Billing_Menu_Container/Search_Result_Container/Search_Result_Content_Container/Search_Summary
@onready var From_Day = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/From_Date_Container/From_Day
@onready var From_Month = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/From_Date_Container/From_Month
@onready var From_Year = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/From_Date_Container/From_Year
@onready var To_Day = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/To_Date_Container/To_Day
@onready var To_Month = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/To_Date_Container/To_Month
@onready var To_Year = $Billing_Menu_Container/Content_Container/Input_And_Button_Container/To_Date_Container/To_Year

@onready var bills_in_search: Dictionary = {}


func _ready():
	EventBus.connect("billing_list_updated", _on_billing_update)
	fill_dates()


func fill_dates():
	for i in range(1,32):
		if i < 10:
			From_Day.add_item("0%d" % i)
			To_Day.add_item("0%d" % i)
		else:
			From_Day.add_item("%d" % i)
			To_Day.add_item("%d" % i)

	for i in range(1, 13):
		if i < 10:
			From_Month.add_item("0%d" % i)
			To_Month.add_item("0%d" % i)
		else:
			From_Month.add_item("%d" % i)
			To_Month.add_item("%d" % i)

	for i in range(2023, 2036):
		From_Year.add_item("%d" % i)
		To_Year.add_item("%d" % i)

	To_Day.selected = -1
	To_Month.selected = -1
	To_Year.selected = -1


func _on_cancel_button_pressed():
	self.queue_free()


func _on_accept_button_pressed():
	var DB = EventBus.database

	var from: String
	var to: String

	from = from + From_Year.text + From_Month.text + From_Day.text

	if To_Year.selected == -1 or To_Month.selected == -1 or To_Day.selected == -1:
		to = from
	else:
		to = to + To_Year.text + To_Month.text + To_Day.text

	if not to.to_int() < from.to_int():
		DB.billing_search(from, to)


func _on_billing_update():
	bills_in_search = DatabaseContent.bill_list

	var total_amount = 0

	for i in bills_in_search.keys():
		Search_Items.add_item(i)
		Search_Items.add_item(bills_in_search[i][0])
		Search_Items.add_item(bills_in_search[i][1])
		Search_Items.add_item(bills_in_search[i][2])

		total_amount = total_amount + bills_in_search[i][1].to_int()

	Search_Summary.text = "Facturas en período: %d\nTotal Facturado: %.2f" % [bills_in_search.size(), total_amount]

	Search_Dialog.show()


func _on_exit_search_pressed():
	Search_Items.clear()
	Search_Dialog.hide()
	To_Day.selected = -1
	To_Month.selected = -1
	To_Year.selected = -1


func _on_from_month_item_selected(index):
	match_month_length(From_Day, index)


func _on_to_month_item_selected(index):
	match_month_length(To_Day, index)


func match_month_length(input: OptionButton, index: int):
	var length: int

	match index:
		1:
			length = 29
		3,5,8,10:
			length = 31
		0,2,4,6,7,9,11:
			length = 32

	correct_days(input, length, index)


func correct_days(input, month_length, index):
	var last_selected_index = input.get_selected()
	input.clear()

	for i in range(1,month_length):
		if i < 10:
			input.add_item("0%d" % i)
		else:
			input.add_item("%d" % i)

	if index < month_length:
		input.selected = last_selected_index


