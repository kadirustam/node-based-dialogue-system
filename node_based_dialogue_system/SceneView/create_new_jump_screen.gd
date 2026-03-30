@tool
extends Control

var jump_menu_item_scene = load("res://addons/node_based_dialogue_system/SceneView/jump_menu_item.tscn")

func _on_close_requested() -> void:
	self.queue_free()

func _ready() -> void:
	SceneViewGlobal.register_create_window(self)
	_load_all_hub_nodes()

func _load_all_hub_nodes() -> void:
	var hub_items = get_tree().get_nodes_in_group("hub_item")
	var container = $Window/Panel/ChooseHubLabel/VBoxContainer
	for i in hub_items:
		container.add_child(_create_jump_menu_item(i.duplicate()))

func _create_jump_menu_item(hub_item: Node) -> Panel:
	var jump_menu_item = jump_menu_item_scene.instantiate()
	jump_menu_item.hub_item = hub_item
	return jump_menu_item
