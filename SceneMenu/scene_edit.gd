@tool
extends Control

var scene_edit_screen = load("res://addons/node_based_dialogue_system/SceneMenu/scene_edit_screen.tscn")
var scene = load("res://addons/node_based_dialogue_system/SceneView/scene_view.tscn")

@onready var delete_confirm = $Panel/ColorRect/HBoxContainer/DeleteSceneButton/DeleteConfirm
@onready var save_file_dialog = $Panel/ColorRect/HBoxContainer/SaveScenesButton/SaveFileDialog
@onready var load_file_dialog = $Panel/ColorRect/HBoxContainer/LoadScenesButton/LoadFileDialog
@onready var scene_list = $Panel/SceneListLabel/SceneList

func _ready() -> void:
	await get_tree().process_frame
	SceneMenuGlobal.load_scene_list(scene_list)
	SceneMenuGlobal.update()

func _on_new_scene_button_pressed() -> void:
	$".".add_child(scene_edit_screen.instantiate())

func _on_save_scenes_button_pressed() -> void:
	save_file_dialog.popup()

func _on_save_file_dialog_file_selected(path: String) -> void:
	var json_string = JSON.stringify(SceneMenuGlobal.save_scenes_to_json(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func _on_load_scenes_button_pressed() -> void:
	load_file_dialog.popup()

func _on_load_file_dialog_file_selected(path: String) -> void:
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		SceneMenuGlobal.load_scenes_from_json(json_file.data)
	else:
		return

func _on_delete_scene_button_pressed() -> void:
	if(SceneMenuGlobal.selected_scene != null):
		delete_confirm.popup()

func _on_delete_confirm_canceled() -> void:
	delete_confirm.queue_free()

func _on_delete_confirm_confirmed() -> void:
	SceneMenuGlobal.remove_selected_scene()

func _on_open_scene_button_pressed() -> void:
	if(SceneMenuGlobal.selected_scene != null):
		var window = scene.instantiate()
		add_child(window)
		#get_tree().change_scene_to_packed(scene)
		#SceneMenuGlobal.add_scene_to_container()
