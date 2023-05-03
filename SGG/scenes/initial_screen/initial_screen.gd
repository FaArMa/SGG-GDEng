extends Control


func _ready():
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	$Login.grab_focus()


func _on_login_pressed():
	get_tree().change_scene_to_file("res://scenes/login_screen/login_screen.tscn")


func _on_register_pressed():
	pass # TODO Crear la escena de registro de usuario


func _on_quit_pressed():
	get_tree().quit()
