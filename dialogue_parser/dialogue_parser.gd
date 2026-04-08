@tool
class_name DialogueParser

@export var dialogue_ressource: Dictionary
var root: Dictionary
var current: Variant

func _init(ressource: Dictionary) -> void:
	dialogue_ressource = ressource
	root = _load_root_node()
	current = root

func get_node_from_data(id: String) -> Variant:
	var found_node: Dictionary
	if(id == "-1"):
		return -1
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

func _handle_next_node(current: Variant) -> Variant:
	if(current is not Dictionary and current == -1):
		return -1
	match(current.type):
		"dialogue": return get_node_from_data(current.next_node)
		"hub": return get_node_from_data(current.id)
		"jump": return get_node_from_data(current.target_node)
		"condition": return get_node_from_data(current.id)
	return null
