@tool
extends Control

@onready var name_edit = $Window/Panel/ConditionNameLabel/ConditionNameEdit
@onready var id_edit = $Window/Panel/ConditionIdLabel/ConditionIdEdit

func _on_window_close_requested() -> void:
	self.queue_free()


func _on_cancel_button_pressed() -> void:
	_on_window_close_requested()


func _on_create_button_pressed() -> void:
	if(name_edit.text.is_empty()):
		$EmptyNameDialog.popup()
		return
	else:
		name_edit.text += "()"
	if(id_edit.text.is_empty()):
		_on_generate_id_button_pressed()
	ConditionMenuGlobal.create_condition_item(name_edit.text, id_edit.text)
	_on_window_close_requested()


func _on_generate_id_button_pressed() -> void:
	id_edit.text = ConditionMenuGlobal.generateId()
