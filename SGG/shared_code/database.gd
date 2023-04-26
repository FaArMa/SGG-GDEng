class_name Database
# La clase se encargará de realizar las consultas a MySQL


# Variables de ejemplo hasta tener MySQL
var test_usr: String = "Test"
var test_pwd: String = "123"
var test_rol: String = "Dueño"


# XXX Dudo que lo necesitemos, pero viene bien para asegurar que tenemos una sola instancia
func _init():
	print("- Constructor de Database -")


# XXX Dudo que lo necesitemos, pero viene bien para asegurar que tenemos una sola instancia
# O quizás finalizar la conexión
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		print("- Destructor de Database -")


# Verificar con la base de datos si el usuario y contraseña son correctos
# TODO Crear la conexión y consulta, ya que la base de datos me dirá si son correctos o no
func is_valid_usr_pwd(usr: String, pwd: String) -> bool:
	return (usr == test_usr && pwd == test_pwd)


# Obtener el rol del usuario en la base de datos
# TODO Crear la conexión y consulta, ya que la base de datos me dirá el rol
func get_usr_role(usr: String) -> String:
	return test_rol
