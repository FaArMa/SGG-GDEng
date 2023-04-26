extends Control


func _ready():
	# XXX Esto debería ir en una escena global así afecta a todos
	DisplayServer.window_set_min_size (Vector2i(1280, 720), 0)
	DisplayServer.window_set_size (Vector2i(1280, 720), 0)
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	$Login.grab_focus()


func _on_login_pressed():
	get_tree().change_scene_to_file("res://login_screen.tscn")


func _on_register_pressed():
	pass # TODO Crear la escena de registro de usuario


func _on_quit_pressed():
	get_tree().quit()
