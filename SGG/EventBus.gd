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


