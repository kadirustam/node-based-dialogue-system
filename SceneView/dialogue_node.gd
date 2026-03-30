@tool
extends GraphNode

@export var node_id: String
@export var actor_name: String
@export var dialogue_text: String
@export var texture: String

func set_up_node(id: String, name: String, dialogue: String, texture_path: String) -> void:
	node_id = id
	actor_name = name
	dialogue_text = dialogue
	texture = texture_path
	$HBoxContainer/VBoxContainer/NameEdit.text = name
	$DialogueEdit.text = dialogue
	$HBoxContainer/Picture.texture = load(texture_path)

func get_dialogue_text() -> String:
	return $DialogueEdit.text
