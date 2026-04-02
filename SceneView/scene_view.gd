@tool
extends Control

var create_condition_node_scene = load("res://addons/node_based_dialogue_system/SceneView/create_new_condition_node.tscn")
var create_dialogue_node_scene = load("res://addons/node_based_dialogue_system/SceneView/create_new_dialogue_screen.tscn")
var create_hub_node_scene = load("res://addons/node_based_dialogue_system/SceneView/create_new_hub_screen.tscn")
var create_jump_node_scene = load("res://addons/node_based_dialogue_system/SceneView/create_new_jump_screen.tscn")
var scene_edit = load("res://addons/node_based_dialogue_system/SceneMenu/scene_edit.tscn")

@onready var graph_editor: GraphEdit = $GraphEdit
@onready var export_dialogue: FileDialog = $ColorRect/HBoxContainer/ExportSceneButton/ExportScene
@onready var context_menu: PopupMenu = $PopupMenu

var temp_drag_data: Dictionary = {"from_node": null, "from_port" : null, "position": null}

func _ready() -> void:
	SceneViewGlobal.register_scene_view($GraphEdit)
	SceneViewGlobal.auto_load_scene()

func _on_new_node_button_pressed() -> void:
	var screen = create_dialogue_node_scene.instantiate()
	add_child(screen)

func _on_new_jump_node_button_pressed() -> void:
	var screen = create_jump_node_scene.instantiate()
	add_child(screen)

func _on_new_condition_node_button_pressed() -> void:
	var screen = create_condition_node_scene.instantiate()
	add_child(screen)

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	$GraphEdit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_new_hub_node_button_pressed() -> void:
	var screen = create_hub_node_scene.instantiate()
	add_child(screen)

func _on_graph_edit_delete_nodes_request(nodes: Array[StringName]) -> void:
	SceneViewGlobal.delete_selected_nodes(nodes)

func _on_delete_selected_node_button_pressed() -> void:
	var nodes: Array[StringName] = SceneViewGlobal.get_selected_node_names()
	SceneViewGlobal.delete_selected_nodes(nodes)

func _on_arange_nodes_button_pressed() -> void:
	$GraphEdit.arrange_nodes()

func _on_return_to_scene_view_button_pressed() -> void:
	SceneViewGlobal.auto_save_scene()
	self.queue_free()

func _on_export_scene_button_pressed() -> void:
	export_dialogue.current_file = SceneMenuGlobal.selected_scene.scene_name.to_snake_case() + "_export"
	export_dialogue.popup()

func _on_export_scene_file_selected(path: String) -> void:
	var json_string = JSON.stringify(SceneViewGlobal.export_scene(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func _on_graph_edit_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	context_menu.position = release_position
	temp_drag_data.from_node = from_node
	temp_drag_data.from_port = from_port
	temp_drag_data.position = release_position
	SceneViewGlobal.add_drag_data(temp_drag_data)
	context_menu.popup()


func _on_popup_menu_id_pressed(id: int) -> void:
	match (id):
		0: _on_new_node_button_pressed()
		1: _on_new_hub_node_button_pressed()
		2: _on_new_jump_node_button_pressed()
		3: _on_new_condition_node_button_pressed()
