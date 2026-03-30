@tool
extends Control

var actor = load("res://addons/node_based_dialogue_system/ActorMenu/actor_edit_screen.tscn")

@export var actor_name: String
@export var actor_id: String
@export var actor_texture: Texture2D
var selected: bool = false

func _ready() -> void:
	$Label.text = actor_name
	$ActorTexture.texture = actor_texture

func load_image_from_path(path: String) -> void:
	actor_texture = load(path)
	$ActorTexture.texture = actor_texture

func get_actor_texture() -> String:
	if(actor_texture != null):
		return actor_texture.load_path
	return ""

func set_up_actor_item(name: String, id: String, path: String) -> void:
	actor_name = name
	actor_id = id
	if(!path.is_empty()):
		load_image_from_path(path)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			ActorMenuGlobal.set_selected_actor(self)

func toggle_selected() -> void:
	selected = !selected
	$SelectMarker.visible = selected
