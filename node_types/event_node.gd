@tool
extends GraphNode

@export var node_id: String
@export var event: String
@export var event_id: String


func set_up_node(n_id: String, name: String) -> void:
	node_id = n_id
	event_id = node_id
	event = name
	$EventName.text = name + "()"
