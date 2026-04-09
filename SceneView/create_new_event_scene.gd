@tool
extends Control

@onready var id_edit: TextEdit = $Window/VBoxContainer/HBoxContainer2/IdEdit
@onready var name_edit: TextEdit = $Window/VBoxContainer/HBoxContainer/NameEdit

func _ready() -> void:
	SceneViewGlobal.register_create_window(self)

func _on_cancel_button_pressed() -> void:
	_on_window_close_requested()

func _on_window_close_requested() -> void:
	self.queue_free()

func _on_generate_button_pressed() -> void:
	id_edit.text = SceneViewGlobal._generate_node_id()


func _on_create_button_pressed() -> void:
	if name_edit.text.is_empty():
		print("Event Name can't be empty")
	elif id_edit.text.is_empty():
		id_edit.text = SceneViewGlobal._generate_node_id()
		_create(id_edit.text, name_edit.text)
	else:
		_create(id_edit.text, name_edit.text)

func _create(id: String, name: String) -> void:
	var drag_data = SceneViewGlobal.drag_data
	if(not drag_data.is_empty()):
		SceneViewGlobal.create_event_node(id, name, drag_data.position, drag_data.from_node, drag_data.from_port)
		SceneViewGlobal.clear_drag_data()
	else:
		SceneViewGlobal.create_event_node(id, name)
