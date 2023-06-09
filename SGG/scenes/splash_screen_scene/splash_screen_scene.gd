extends Control


func _ready():
	$InitialScreen.connect("switched_to_login", _on_switch_to_login)
	$InitialScreen.connect("switched_to_register", _on_switch_to_register)
	$LoginScreen.connect("login_screen_return", _on_switch_to_initial)
	$RegisterScreen.connect("register_screen_return", _on_switch_to_initial)


func _init():
	add_child(EventBus.database)


func _on_switch_to_login():
	$InitialScreen.hide()
	$LoginScreen.show()


func _on_switch_to_register():
	$InitialScreen.hide()
	$RegisterScreen.show()


func _on_switch_to_initial():
	$LoginScreen.hide()
	$RegisterScreen.hide()
	$InitialScreen.show()

