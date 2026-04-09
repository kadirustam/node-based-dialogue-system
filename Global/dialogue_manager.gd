@tool
extends Node

@export var dialogue_ui: Control
var parser: DialogueParser

func start_conversation(scene: Dictionary) -> void:
	parser = DialogueParser.new(scene)
	#dialogue_ui.instantiate()

func end_conversation() -> void:
	dialogue_ui.queue_free()
	parser = null

func get_first_node() -> Dictionary:
	return parser.root

func get_next_node() -> Variant:
	var next = parser.get_next_node()
	if(next is Dictionary):
		if(next.type == "dialogue"):
			parser.set_next_node(next.id)
			return next
		if(next.type == "hub"):
			return _hub_interactions(next.next_nodes)
		if(next.type == "jump"):
			return handle_user_interaction(next.target_node)
		if(next.type == "condition"):
			return _pass_skill_check(next, false)
	else:
		end_conversation()
	return ""

func get_dialogue_text_from_node(id: String) -> String:
	var node: Dictionary = parser.get_node_from_data(id)
	return node.dialogue_text

func handle_user_interaction(id: String = "") -> Variant:
	parser.set_next_node(id)
	return get_next_node()

func is_dialogue_next() -> bool:
	var next : Variant = parser.get_next_node()
	if(next is Dictionary and next.type == "dialogue"):
		return true
	return false

func is_hub_next() -> bool:
	var next : Variant = parser.get_next_node()
	if(next is Dictionary and next.type == "hub"):
		return true
	return false

func is_condition_next() -> bool:
	var next : Variant = parser.get_next_node()
	if(next is Dictionary and next.type == "condition"):
		return true
	return false

func is_jump_next() -> bool:
	var next : Variant = parser.get_next_node()
	if(next is Dictionary and next.type == "jump"):
		return true
	return false

func is_end_next() -> bool:
	var next : Variant = parser.get_next_node()
	if(next is not Dictionary and next == -1):
		return true
	return false

func _hub_interactions(next_nodes: Array) -> Dictionary:
	var user_interactions: Dictionary
	for node in next_nodes:
		user_interactions[node] = parser.get_node_from_data(node)
	return user_interactions

func _pass_skill_check(next: Dictionary, result: bool) -> Variant:
	if(result):
		parser.set_next_node(next.next_node_after_success)
		return parser.get_node_from_data(next.next_node_after_success)
	else:
		parser.set_next_node(next.next_node_after_failure)
		return parser.get_node_from_data(next.next_node_after_failure)
