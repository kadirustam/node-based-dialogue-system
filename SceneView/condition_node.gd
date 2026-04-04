@tool
extends GraphNode

@export var node_id: String
@export var condition_name: String
@export var condition_id: String
@export var condition_type: String


func set_up_node(n_id: String, name: String, id: String, type: String) -> void:
	node_id = n_id
	condition_name = name
	condition_id = id
	_set_condition_type(type)
	$ConditionEdit.text = name

func _set_condition_type(type: String) -> void:
	var group = $HBoxContainer/ActiveCheckBox.button_group.get_buttons()
	for button: Button in group:
		if button.text.to_lower() == type:
			condition_type = type
			button.button_pressed = true
