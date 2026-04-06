@tool
class_name DialogueParser

@export var dialogue_ressource: Dictionary
var root: Dictionary
var current: Dictionary

func _init(ressource: Dictionary) -> void:
	dialogue_ressource = ressource
	root = _load_root_node()
	current = root

func get_node_from_data(id: String) -> Dictionary:
	var found_node: Dictionary
	for entry in dialogue_ressource:
		var node = dialogue_ressource.get(entry)
		if(node.id == id):
			found_node = node
	return found_node

func _load_root_node() -> Dictionary:
	var root_node: Dictionary
	for entry in dialogue_ressource:
		var node = dialogue_ressource.get(entry)
		if(node.has("isRoot")):
			root_node = node
	return root_node

func get_next_node() -> Variant:
	return _handle_next_node(current)

func set_next_node(id: String = "") -> void:
	if(id.is_empty()):
		current = _handle_next_node(current)
	else:
		current = get_node_from_data(id)

func _handle_next_node(current: Dictionary) -> Variant:
	match(current.type):
		"dialogue": return get_node_from_data(current.next_node)
		"hub": return get_hub_interactions(current.next_nodes)
		"jump": return get_node_from_data(current.target_node)
		"condition": return skill_check(current)
	return null

func get_hub_interactions(next_nodes: Array) -> Dictionary:
	var user_interactions: Dictionary
	for node in next_nodes:
		user_interactions[node] = get_node_from_data(node)
	return user_interactions

func skill_check(current: Dictionary) -> Dictionary:
	if((randi() % 100) % 2 == 0):
		return get_node_from_data(current.next_node_after_success)
	else:
		return get_node_from_data(current.next_node_after_failure)
