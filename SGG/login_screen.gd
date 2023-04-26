extends Control


@onready var DB = Database.new()
@onready var usr = $LineEditUsername
@onready var pwd = $LineEditPassword
@onready var error_label = $LabelIncorrectUsrPwd
@onready var login_button = $ButtonLogin


func _ready():
	# XXX Esto debería ir en una escena global así afecta a todos
	DisplayServer.window_set_min_size(Vector2i(1280, 720), 0)
	DisplayServer.window_set_size(Vector2i(1280, 720), 0)
	# Al darle el foco se puede manejar con teclado sin necesidad de hacer clic antes
	$LineEditUsername.grab_focus()


func _on_button_login_pressed():
	login_button.disabled = true
	if DB.is_valid_usr_pwd(usr.text, pwd.text):
		print("[OK] Usuario y contraseña correctos")
		# 1. Ahora que se que el usuario y contraseña son correctos
		#    debería obtener el rol del usuario
		# 2. Al tener el rol del usuario, mover a la escena que le corresponda
		#    (como Main, Cocina, Bebida, etc.)
		match DB.get_usr_role(usr.text):
			"Dueño":
				print("[OK] El rol del mismo es Dueño")
			_:
				print("[ERROR] El rol del mismo no pudo ser obtenido")
	else:
		print("[ERROR] Usuario y/o contraseña incorrectos")
		error_label.visible = true


func _on_line_edit_text_changed(_new_text):
	login_button.disabled = false
	error_label.visible = false


func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://initial_screen.tscn")
