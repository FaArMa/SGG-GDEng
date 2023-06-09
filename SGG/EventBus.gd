#Event Bus Singleton
extends Node


signal tables_modified(_tables: Dictionary)
signal walls_modified(_walls: Array)
signal system_accessed


var database: Database = Database.new()

