extends Control

func _ready():
	$InitialScreen.connect("switched_to_login", _on_switch_to_login)
	$InitialScreen.connect("switched_to_register", _on_switch_to_register)
	$LoginScreen.connect("switched_to_initial", _on_switch_to_initial)
	$RegisterScreen.connect("switched_to_initial", _on_switch_to_initial)


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
