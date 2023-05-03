extends Node2D

@onready var mesa_libre = preload("res://scenes/mesa/mesa_libre.png")
@onready var mesa_seleccionada = preload("res://scenes/mesa/mesa_seleccionada.png")
@onready var mesa_ocupada = preload("res://scenes/mesa/mesa_ocupada.png")
@onready var nombre_mesa

func init(_pos: Vector2, _nom: String):
	self.position = _pos
	nombre_mesa = _nom
	mostrar_nombre(nombre_mesa)
	$Area_Mesa/Icono_Mesa.set_texture(mesa_libre)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click_izquierdo"):
		$Area_Mesa/Icono_Mesa.set_texture(mesa_seleccionada)

func mostrar_nombre(_nom: String):
	$Area_Mesa/Icono_Mesa/Texto_Mesa.set_text(_nom)
