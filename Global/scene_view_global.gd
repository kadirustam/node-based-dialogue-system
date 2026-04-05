@tool
extends Node

var dialogue_node_scene = load(
	"res://addons/node_based_dialogue_system/SceneView/dialogue_node.tscn")
var hub_node_scene = load(
	"res://addons/node_based_dialogue_system/SceneView/hub_node.tscn")
var jump_node_scene = load(
	"res://addons/node_based_dialogue_system/SceneView/jump_node.tscn")
var condition_node_scene = load(
	"res://addons/node_based_dialogue_system/SceneView/condition_node.tscn")

@onready var graph: GraphEdit
@onready var window

var chars: Array = ['o', 'p', 'q', 'r', 's']
@export var drag_data : Dictionary

func create_dialogue_node(actor: Node, dialogue_text: String,
	node_id: String = _generate_node_id()) -> void:
		_close_window()
		var dialogue_node = dialogue_node_scene.instantiate()
		dialogue_node.set_up_node(node_id, actor.actor_name, dialogue_text, actor.get_actor_texture())
		graph.add_child(dialogue_node)

func create_and_connect_dialogue_node(actor: Node, dialogue_text: String,
	position: Vector2 = Vector2(0,0), from_node = null, from_port = null,
	node_id: String = _generate_node_id()) -> void:
		_close_window()
		var dialogue_node = dialogue_node_scene.instantiate()
		dialogue_node.set_up_node(node_id, actor.actor_name,dialogue_text, actor.get_actor_texture())
		graph.add_child(dialogue_node)
		_move_node_to_position(dialogue_node, position, from_node, from_port)

func create_hub_node(hub_id: String, hub_name: String, position: Vector2 = Vector2(0,0),
from_node = null, from_port = null) -> void:
	_close_window()
	var hub_node = hub_node_scene.instantiate()
	hub_node.set_up_node(hub_id, hub_name)
	graph.add_child(hub_node)
	_move_node_to_position(hub_node, position, from_node, from_port)

func create_jump_node(hub_name: String, hub_id: String,
	node_id: String = _generate_node_id()) -> void:
		_close_window()
		var jump_node = jump_node_scene.instantiate()
		jump_node.set_up_node(node_id, hub_name, hub_id)
		graph.add_child(jump_node)

func create_and_connect_jump_node(hub_name: String, hub_id: String, position: Vector2 = Vector2(0,0), from_node = null, from_port = null,
	node_id: String = _generate_node_id()) -> void:
		_close_window()
		var jump_node = jump_node_scene.instantiate()
		jump_node.set_up_node(node_id, hub_name, hub_id)
		graph.add_child(jump_node)
		_move_node_to_position(jump_node, position, from_node, from_port)

func create_condition_node(name: String, id: String, type: String,
	node_id: String = _generate_node_id()) -> void:
		_close_window()
		var condition_node = condition_node_scene.instantiate()
		condition_node.set_up_node(node_id, name, id, type)
		graph.add_child(condition_node)

func create_and_connect_condition_node(name: String, id: String, type: String, position: Vector2 = Vector2(0,0), from_node = null, from_port = null,
	node_id: String = _generate_node_id()) -> void:
		_close_window()
		var condition_node = condition_node_scene.instantiate()
		condition_node.set_up_node(node_id, name, id, type)
		graph.add_child(condition_node)
		_move_node_to_position(condition_node, position, from_node, from_port)

func add_drag_data(dict: Dictionary) -> void:
	drag_data = dict

func clear_drag_data() -> void:
	drag_data = {}

func auto_save_scene() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/scene_data/" + SceneMenuGlobal.selected_scene.scene_name.to_snake_case() + ".json"
	var json_string = JSON.stringify(SceneViewGlobal._save_to_scene(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)
	print("Saved " + SceneMenuGlobal.selected_scene.scene_name.to_snake_case())

func auto_load_scene() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/scene_data/" + SceneMenuGlobal.selected_scene.scene_name.to_snake_case() + ".json"
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		SceneViewGlobal._load_to_scene(json_file.data)
		print(SceneMenuGlobal.selected_scene.scene_name.to_snake_case() + " loaded")
	else:
		return

func export_scene() -> Dictionary:
	var dict_to_json: Dictionary
	_export_dialogue_nodes(dict_to_json)
	_export_hub_nodes(dict_to_json)
	_export_jump_nodes(dict_to_json)
	_export_condition_nodes(dict_to_json)
	return dict_to_json

func get_selected_node_names() -> Array[StringName]:
	var names: Array[StringName] = []
	for child in graph.get_children():
		if child is GraphNode and child.selected:
			names.append(child.name)
	return names

func delete_selected_nodes(nodes: Array[StringName]) -> void:
	for node in nodes:
		graph.get_node(NodePath(node)).queue_free()

func has_id(id: String) -> bool:
	return false

func _generate_node_id() -> String:
	return str(
		randi_range(0,9)) + chars.pick_random() + str(randi_range(10000,99999))

func register_scene_view(view: Control) -> void:
	graph = view

func register_create_window(view: Control) -> void:
	window = view

func _move_node_to_position(node: GraphNode, position: Vector2, from_node, from_port) -> void:
	node.position_offset = (position + graph.scroll_offset) / graph.zoom
	if(from_node != null && from_port != null):
		graph.connect_node(from_node, from_port, node.name, 0)

func _close_window() -> void:
	if(window):
		window.queue_free()

func _save_dialogue_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("dialogue_nodes"):
		dict_to_json[node.node_id] = { "type": "dialogue", "node_id": node.node_id,
			"actor_name": node.actor_name, "dialogue_text": node.get_dialogue_text(), "texture": node.texture }

func _save_hub_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("hub_nodes"):
		dict_to_json[node.node_id] = { "type": "hub", "node_id": node.node_id,
			"hub_id": node.hub_id, "hub_name": node.hub_name }

func _save_jump_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("jump_nodes"):
		dict_to_json[node.node_id] = { "type": "jump", "node_id": node.node_id, "target_id": node.target_id, "target_name": node.target_name }

func _save_condition_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("condition_nodes"):
		dict_to_json[node.node_id] = { "type": "condition", "node_id": node.node_id, "condition_id": node.condition_id, "condition_name": node.condition_name,
			"condition_type": node.condition_type }

func _save_all_connections(dict_to_json: Dictionary) -> void:
	var all_nodes = _get_all_nodes()
	var connections = graph.get_connection_list()
	for node in all_nodes:
		if not dict_to_json[node.node_id].has("connections"):
			dict_to_json[node.node_id]["connections"] = []
		for connection in connections:
			if(connection.from_node == node.name):
				var data = {"from_node": node.node_id, "from_port": connection.from_port, "to_node": graph.get_node(str(connection.to_node)).node_id,
					"to_port": connection.to_port}
				dict_to_json[node.node_id]["connections"].append(data)

func _get_all_nodes() -> Array:
	var all_nodes = []
	all_nodes.append_array(get_tree().get_nodes_in_group("dialogue_nodes"))
	all_nodes.append_array(get_tree().get_nodes_in_group("hub_nodes"))
	all_nodes.append_array(get_tree().get_nodes_in_group("jump_nodes"))
	all_nodes.append_array(get_tree().get_nodes_in_group("condition_nodes"))
	return all_nodes

func _get_node_from_id(node_id: String) -> Node:
	var all_nodes = _get_all_nodes()
	for node in all_nodes:
		if(node.node_id == node_id):
			return node
	return null

func _create_node_from_data(entry: Variant) -> void:
	match entry.type:
		"dialogue": create_dialogue_node(ActorMenuGlobal.get_actor_from_list(entry.actor_name), entry.dialogue_text, entry.node_id)
		"hub": create_hub_node(entry.hub_id, entry.hub_name)
		"jump": create_jump_node(entry.target_name, entry.target_id, entry.node_id)
		"condition": create_condition_node(entry.condition_name,entry.condition_id, entry.condition_type, entry.node_id)

func _create_connections_from_data(connections: Variant) -> void:
	for connection in connections:
		graph.connect_node(
			_get_node_from_id(connection.from_node).name, connection.from_port,
			_get_node_from_id(connection.to_node).name, connection.to_port
			)
		print("connected " + _get_node_from_id(connection.from_node).name + " and " + _get_node_from_id(connection.to_node).name)

func _export_dialogue_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("dialogue_nodes"):
		dict_to_json[node.node_id] = { "type": "dialogue", "id": node.node_id,
			"actor_name": node.actor_name,
			"dialogue_text": node.get_dialogue_text(),
			"next_node": _get_next_node_for_dialogue(node)
		}

func _export_hub_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("hub_nodes"):
		dict_to_json[node.node_id] = { "type": "hub", "id": node.node_id,
			"next_nodes": _get_next_nodes_for_hub(node)
		}

func _export_jump_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("jump_nodes"):
		dict_to_json[node.node_id] = { "type": "jump", "id": node.node_id,
			"target_node": node.target_id
		}

func _export_condition_nodes(dict_to_json: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("condition_nodes"):
		var condition_results: Array = _get_next_nodes_for_condition(node)
		dict_to_json[node.node_id] = { "type": "condition", "id": node.node_id,
			"condition_to_check": node.condition_name,
			"condition_type": node.condition_type,
			"next_node_after_success": condition_results[0],
			"next_node_after_failure": condition_results[1]
		}

func _get_next_node_for_dialogue(node: GraphNode) -> String:
	var node_id: String
	for connection in graph.get_connection_list_from_node(node.name):
		if(graph.get_node(str(connection.to_node)).node_id != node.node_id):
			node_id = graph.get_node(str(connection.to_node)).node_id
			return node_id
	return "-1"

func _get_next_nodes_for_hub(node: GraphNode) -> Array:
	var nodes: Array
	for connection in graph.get_connection_list_from_node(node.name):
		if(graph.get_node(str(connection.to_node)).node_id != node.node_id):
			nodes.append(graph.get_node(str(connection.to_node)).node_id)
	return nodes

func _get_next_nodes_for_condition(node: GraphNode) -> Array:
	var nodes: Array
	for connection in graph.get_connection_list_from_node(node.name):
		print(connection)
		if(graph.get_node(str(connection.to_node)).node_id != node.node_id):
			nodes.append(graph.get_node(str(connection.to_node)).node_id)
	return nodes

func _save_to_scene() -> Dictionary:
	var dict_to_json: Dictionary
	_save_dialogue_nodes(dict_to_json)
	_save_hub_nodes(dict_to_json)
	_save_jump_nodes(dict_to_json)
	_save_condition_nodes(dict_to_json)
	_save_all_connections(dict_to_json)
	return dict_to_json

func _load_to_scene(json_data: Dictionary) -> void:
	graph.clear_connections()
	for entry in json_data:
		_create_node_from_data(json_data.get(entry))
	for entry in json_data:
		if(json_data.get(entry).connections):
			_create_connections_from_data(json_data.get(entry).connections)
	graph.arrange_nodes()
