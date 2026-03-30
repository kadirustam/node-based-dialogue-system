@tool
extends GraphNode

@export var node_id: String
@export var hub_id: String
@export var hub_name: String

func set_up_node(h_id: String, h_name: String) -> void:
	node_id = h_id
	hub_id = h_id
	hub_name = h_name
	$HubItem.hub_name = hub_name
	$HubItem.hub_id = hub_id
