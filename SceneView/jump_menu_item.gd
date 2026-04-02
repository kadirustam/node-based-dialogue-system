@tool
extends Panel

@export var hub_item: Node

func _ready() -> void:
	$Label.text = hub_item.hub_name

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var drag_data: Dictionary = SceneViewGlobal.drag_data
			if not drag_data.is_empty():
				SceneViewGlobal.create_and_connect_jump_node(hub_item.hub_name, hub_item.hub_id, drag_data.position, drag_data.from_node, drag_data.from_port)
			else:
				SceneViewGlobal.create_jump_node(hub_item.hub_name, hub_item.hub_id)
