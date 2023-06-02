extends Control

signal text_submit(text)

func _on_dialog_window_close_requested():
	self.queue_free()

func _on_accept_button_pressed():
	var text = $Dialog_Window/Input.text
	text = text.strip_edges(true,true)
	text = text.to_upper()
	if not text == "":
		emit_signal("text_submit", text)
	self.queue_free()
