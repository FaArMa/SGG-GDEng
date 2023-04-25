extends Button

func _on_pressed():
	self.disabled = true
	$"../LabelIncorrectUsrPwd".visible = false
	var usr = $"../LineEditUsername".text
	var pwd = $"../LineEditPassword".text
	if is_valid_usr_pwd(usr, pwd):
		# 1. Ahora que se que el usuario y contraseña son correctos
		#    debería obtener el rol del usuario
		# 2. Al tener el rol del usuario, mover a la escena que la corresponda
		#    (como Main, Cocina, Bebida, etc.)
		pass
	else:
		$"../LabelIncorrectUsrPwd".visible = true
	self.disabled = false

# Verificar con la base de datos si el usuario y contraseña son correctos
# TODO Crear la conexión y consulta, ya que la base de datos me dirá si son correctos o no
func is_valid_usr_pwd(usr: String, pwd: String) -> bool:
	return (usr == "Test" && pwd == "123")

# Obtener el rol del usuario en la base de datos
# TODO Crear la conexión y consulta, ya que la base de datos me dirá el rol
func get_usr_role(usr: String) -> String:
	print("El rol del usuario " + usr + " es " + "INJUNABLE")
	return "INJUNABLE"
