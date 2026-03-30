@tool
extends GraphNode

@export var node_id: String
@export var condition_name: String
@export var condition_id: String

func set_up_node(n_id: String, name: String, id: String) -> void:
	node_id = n_id
	condition_name = name
	condition_id = id
	$ConditionEdit.text = name
