extends Node2D

@onready var Mesa = preload("res://scenes/mesa/mesa.tscn")
@onready var Ingreso_Texto = preload("res://scenes/ingreso_texto/ingreso_texto.tscn")
@onready var editar_mesas = false
@onready var ubicacion_mesas = {}

func _ready():
	var menu2 = $MenuBar/MenuButton2.get_popup()
	menu2.connect("id_pressed", _id_boton)

func _id_boton(id):
	if id == 0:
		toggle_editar_mesas()

func toggle_editar_mesas():
	if not $menu_edicion.is_visible():
		$menu_edicion.show()
		$Area_Edicion_Mesas.show()
	else:
		$menu_edicion.hide()
		$Area_Edicion_Mesas.hide()

func _on_boton_salir_pressed():
	toggle_editar_mesas()

func _on_area_edicion_mesas_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click_izquierdo") and editar_mesas:
		var ingreso = Ingreso_Texto.instantiate()
		add_child(ingreso)
		var texto_ingresado = ingreso.get_text()
		#var nueva_mesa = Mesa.new(event.position)
		var nueva_mesa = Mesa.instantiate()
		nueva_mesa.init(event.position, texto_ingresado)
		add_child(nueva_mesa)
		editar_mesas = false;
		$Area_Edicion_Mesas/Color_Edicion_Mesas.hide()

func _on_agregar_mesa_pressed():
	$Area_Edicion_Mesas/Color_Edicion_Mesas.show()
	editar_mesas = true;
