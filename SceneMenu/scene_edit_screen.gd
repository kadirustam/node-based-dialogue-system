@tool
extends Control

var scene_item = load("res://addons/node_based_dialogue_system/SceneMenu/scene_item.tscn")
@onready var scene_name_edit = $Window/Panel/NameLabel/NameEdit
@onready var scene_id_edit = $Window/Panel/IdLabel/IdEdit

func _on_window_close_requested() -> void:
	self.queue_free()

func _on_cancal_button_pressed() -> void:
	_on_window_close_requested()

func _on_generate_id_button_pressed() -> void:
	scene_id_edit.text = SceneMenuGlobal.generate_id()

func _on_add_scene_button_pressed() -> void:
	_create_scene()
	SceneMenuGlobal.update()
	_on_window_close_requested()

func _create_scene() -> void:
	if(scene_name_edit.text.is_empty()):
		scene_name_edit.text = "NewScene"
	if(scene_id_edit.text.is_empty()):
		scene_id_edit.text = SceneMenuGlobal.generate_id()
	SceneMenuGlobal.create_scene_item(scene_name_edit.text, scene_id_edit.text)
