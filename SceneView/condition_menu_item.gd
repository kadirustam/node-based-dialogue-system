@tool
extends Panel

@export var condition_name: String
@export var condition_id: String

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SceneViewGlobal.create_condition_node(condition_name, condition_id)

func set_up_condition_node(name: String, id: String) -> void:
	condition_name = name
	condition_id = id
	$ConditionLabel.text = condition_name
