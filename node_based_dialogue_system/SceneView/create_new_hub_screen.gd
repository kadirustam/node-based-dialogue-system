@tool
extends Control

var hub_node_scene = load("res://addons/node_based_dialogue_system/SceneView/hub_node.tscn")
var hub_item_scene = load("res://addons/node_based_dialogue_system/SceneView/hub_item.tscn")

@onready var hub_name_edit = $Window/Panel/HubNameLabel/HubNameEdit
@onready var hub_id_edit = $Window/Panel/HubIdLabel/HubIdEdit

var chars: Array = ['h', 'i', 'j']

func _on_close_requested() -> void:
	self.queue_free()

func _ready() -> void:
	SceneViewGlobal.register_create_window(self)

func _on_create_hub_node_button_pressed() -> void:
	_create_hub()
	SceneViewGlobal.create_hub_node(_generateId(), "Unnamed Hub")
	hub_name_edit.clear()
	hub_id_edit.clear()
	_on_close_requested()

func _on_hub_id_generate_button_pressed() -> void:
	hub_id_edit.text = _generateId()

func _create_hub() -> void:
	var hub_node = hub_node_scene.instantiate()
	var hub_item = hub_item_scene.instantiate()
	if(hub_name_edit.text.is_empty()):
		hub_item.hub_name = "Unnamed Hub"
	else:
		hub_item.hub_name = hub_name_edit.text
	if(hub_id_edit.text.is_empty()):
		hub_item.hub_id = _generateId()
	else:
		hub_item.hub_id = hub_id_edit.text

func _generateId() -> String:
	var id: String
	id = str(randi_range(0,9)) + chars.pick_random() + str(randi_range(10000,99999))
	if(!SceneViewGlobal.has_id(id)):
		return id
	else:
		return _generateId()
