extends Control

@onready var texto = ""

func _on_window_close_requested():
	self.queue_free()

func _on_button_pressed():
	texto = $Window/TextEdit.text
	self.queue_free()

func get_text() -> String:
	return texto
