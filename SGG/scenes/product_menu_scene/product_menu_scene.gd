extends Control

@onready var existing_products: Dictionary = {}
@onready var existing_ingredients: Dictionary = {}

#	PRODUCTOS
#	{
#		"Fernet C/Coca": [[1200, "bebida"], ["fernet", "coca"], [0.06, 0.24]],
#		"Hamburguesa con Lechuga": [[2300, "comida"], ["carne", "pan", "lechuga"], [210, 150, 40]],
#		"Fugazzeta": [[1900, "comida"], ["masa", "cebolla"], [400, 350]]
#	}
#
#	print(existing_products["Fernet C/Coca"])		#[[1200, "bebida"], ["fernet", "coca"], [0.06, 0.24]]
#	print(existing_products["Fernet C/Coca"][0])	#[1200, "bebida"]
#	print(existing_products["Fernet C/Coca"][1][0])	#fernet
#	print(existing_products["Fernet C/Coca"][2][1])	#0.24
#
#	INGREDIENTES
#{
#	"carne": "gr",
#	"fernet": "lt",
#	"coca": "lt",
#	"cebolla": "gr"
#}

var Existing_Product_Name
var Existing_Product_Price
var Existing_Product_Type

var Existing_Ingredient_Name

var Selected_Ingredient_Name

func _ready():

	existing_products = DatabaseContent.product_list
	existing_ingredients = DatabaseContent.all_available_ingredients

	#NODE DEFINITIONS
	Existing_Product_Name = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Text_Container/Existing_Product_Name
	Existing_Product_Price = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Text_Container/Existing_Product_Price
	Existing_Product_Type = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Product_Input_Container/Existing_Product_Text_Container/Existing_Product_Type

	Existing_Ingredient_Name = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Existing_Ingredient_Container/Existing_Ingredient_Name

	Selected_Ingredient_Name = $Product_Menu_Block_Container/Product_Menu_Scroll_Container/Product_Main_Menu_container/Selected_Ingredient_Container/Selected_Ingredient_Name

	load_existing_products()
	load_existing_ingredients()

	Existing_Product_Name.selected = -1


func load_existing_products():
	for i in existing_products.keys():
		Existing_Product_Name.add_item(i)


func load_existing_ingredients():
	for i in existing_ingredients.keys():
			Existing_Ingredient_Name.add_item(i)


func _on_exit_button_pressed():
	self.queue_free()


func _on_existing_product_name_item_selected(index):
	Selected_Ingredient_Name.clear()
	var product_name = Existing_Product_Name.get_item_text(index)
	Existing_Product_Price.set_text(str(existing_products[product_name][0][0]))
	Existing_Product_Type.selected = 1 if existing_products[product_name][0][1] == "bebida" else 0

	var product_ingredient
	var ingredient_name
	var ingredient_unit
	var ingredient_amount

	for i in existing_products[product_name][1].size():

		ingredient_name = existing_products[product_name][1][i]
		ingredient_amount = existing_products[product_name][2][i]
		ingredient_unit = existing_ingredients[ingredient_name]

		product_ingredient = "%s, %s %s" % [ingredient_name, ingredient_amount, ingredient_unit]
		Selected_Ingredient_Name.add_item(product_ingredient)
