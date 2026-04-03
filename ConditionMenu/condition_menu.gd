@tool
extends Control

var create_condition_screen = load("res://addons/node_based_dialogue_system/ConditionMenu/condition_edit_screen.tscn")

@onready var save_dialog = $Panel/ColorRect/HBoxContainer/SaveConditionsButton/SaveDialog
@onready var load_dialog = $Panel/ColorRect/HBoxContainer/LoadConditionsButton/LoadDialog

func _ready() -> void:
	await get_tree().process_frame
	ConditionMenuGlobal.load_condition_list($Panel/ConditionList/VBoxContainer)
	ConditionMenuGlobal.update()

func _on_new_condition_button_pressed() -> void:
	$Panel/ColorRect/HBoxContainer/NewConditionButton.add_child(create_condition_screen.instantiate())

func _on_remove_condition_button_pressed() -> void:
	ConditionMenuGlobal.remove_selected_condition()

func _on_save_conditions_button_pressed() -> void:
	save_dialog.popup()

func _on_save_dialog_file_selected(path: String) -> void:
	var json_string = JSON.stringify(ConditionMenuGlobal.save_scenes_to_json(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func _on_load_conditions_button_pressed() -> void:
	load_dialog.popup()

func _on_load_dialog_file_selected(path: String) -> void:
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		ConditionMenuGlobal.load_scenes_from_json(json_file.data)
	else:
		return
