#Event Bus Singleton
extends Node

var database: Database = Database.new()

signal tables_modified(_tables: Dictionary)
signal walls_modified(_walls: Array)

signal response_product_list(products)
signal response_available_ingredients(available_ingredients)
signal response_product_ingredient_list(ingredients)
signal response_product_ingredient_amount_list(amounts)
signal response_get_user_list(users)
signal response_get_user_info(user)

signal user_list_updated()
signal product_list_updated()
signal billing_list_updated()

signal response_modify_product(product) #nombre y precio
signal response_delete_product(product) #nombre
signal response_add_product(product) #incluye ingredientes y toda la bola

signal response_billing_search(result)
