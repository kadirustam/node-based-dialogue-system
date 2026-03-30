@tool
extends Panel

@export var hub_item: Node

func _ready() -> void:
	$Label.text = hub_item.hub_name

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SceneViewGlobal.create_jump_node(hub_item.hub_name, hub_item.hub_id)
