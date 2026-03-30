@tool
extends GraphNode

@export var node_id: String
@export var target_name: String
@export var target_id: String

func set_up_node(n_id: String, name: String, id: String) -> void:
	node_id = n_id
	target_name = name
	target_id = id
	$HBoxContainer/TargetHub.text = target_name
