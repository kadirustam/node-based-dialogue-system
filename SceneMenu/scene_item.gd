@tool
extends Control

@export var scene_name: String
@export var scene_id: String
var selected: bool = false

func _ready() -> void:
	$Label.text = scene_name

func set_up_scene_item(name: String, id: String) -> void:
	scene_name = name
	scene_id = id
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_selected()
			SceneMenuGlobal.set_selected_scene(self)

func toggle_selected() -> void:
	selected = !selected
	$SelectMarker.visible = selected
