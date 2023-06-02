extends Node2D

signal wall_clicked(wall)


var wall_position: Vector2:
	set(value):
		wall_position = value
	get:
		return wall_position


func _on_wall_area_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		emit_signal("wall_clicked", self)


func delete_wall(_wall: Object):
	_wall.queue_free()
