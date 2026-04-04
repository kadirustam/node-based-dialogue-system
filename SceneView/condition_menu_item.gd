@tool
extends Panel

@export var condition_name: String
@export var condition_id: String
@export var condition_type: String

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var drag_data: Dictionary = SceneViewGlobal.drag_data
			if not drag_data.is_empty():
				SceneViewGlobal.create_and_connect_condition_node(condition_name, condition_id, condition_type, drag_data.position, drag_data.from_node, drag_data.from_port)
			else:
				SceneViewGlobal.create_condition_node(condition_name, condition_id, condition_type)

func set_up_condition_node(name: String, id: String, type: String) -> void:
	condition_name = name
	condition_id = id
	condition_type = type
	$ConditionLabel.text = condition_name
