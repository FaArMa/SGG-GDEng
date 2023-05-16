extends Control

signal text_submit(text)
signal text_discard

func _on_dialog_window_close_requested():
	emit_signal("text_discard")
	self.queue_free()

func _on_accept_button_pressed():
	var text = $Dialog_Window/Input.text
	text = text.strip_edges(true,true)
	if not text == "":
		emit_signal("text_submit", text)
	self.queue_free()
