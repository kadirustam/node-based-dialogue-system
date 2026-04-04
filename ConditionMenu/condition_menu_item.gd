@tool
extends Panel

@export var condition_name: String
@export var condition_id: String
@export var condition_type: String
var selected: bool = false


func set_up_condition(name: String, id: String, type: String) -> void:
	condition_name = name
	condition_id = id
	condition_type = type
	$ConditionLabel.text = condition_name


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			ConditionMenuGlobal.set_selected_condition(self)

func toggle_selected() -> void:
	selected = !selected
	$SelectMarker.visible = selected
