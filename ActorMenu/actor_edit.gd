@tool
extends Control

var actor_edit_screen = load("res://addons/node_based_dialogue_system/ActorMenu/actor_edit_screen.tscn")
@onready var actor_list = $ActorListLabel/ActorList

func _ready() -> void:
	ActorMenuGlobal.load_actors()

func _draw() -> void:
	ActorMenuGlobal.load_actor_list(actor_list)
	ActorMenuGlobal.update()

func _on_button_pressed() -> void:
	$".".add_child(actor_edit_screen.instantiate())

func _on_save_actors_button_pressed() -> void:
	$Panel/ColorRect/HBoxContainer/SaveActorsButton/SaveJson.popup()

func _on_save_json_file_selected(path: String) -> void:
	var json_string = JSON.stringify(ActorMenuGlobal.save_json(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func _on_load_actors_button_pressed() -> void:
	$Panel/ColorRect/HBoxContainer/LoadActorsButton/FileDialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		ActorMenuGlobal.load_json(json_file.data)
	else:
		return

func _on_edit_actor_button_pressed() -> void:
	ActorMenuGlobal.edit_selected_actor()

func _on_remove_actor_button_pressed() -> void:
	ActorMenuGlobal.remove_selected_actor()

func _clear_actor_list() -> void:
	var children = actor_list.get_children()
	for c in children:
		actor_list.remove_child(c)
		c.queue_free()
