@tool
extends Control

@onready var actor_name = $Window/Panel/NameLabel/NameEdit
@onready var actor_id = $Window/Panel/IdLabel/IdEdit
@onready var actor_texture = $Window/Panel/PictureLabel/PictureTexture
var actor_item = load("res://addons/node_based_dialogue_system/ActorMenu/actor_edit_item.tscn")

func _on_window_close_requested() -> void:
	self.queue_free()

func _on_cancel_pressed() -> void:
	_on_window_close_requested()

func _on_picture_add_button_pressed() -> void:
	$Window/Panel/PictureLabel/FileDialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	actor_texture.texture = load(path)

func _on_generate_id_button_pressed() -> void:
	actor_id.text = ActorMenuGlobal.generate_id()

func _on_add_button_pressed() -> void:
	if(!ActorMenuGlobal.has_id(actor_id.text)):
		_create_actor()
	else:
		_edit_actor(actor_id.text)
	ActorMenuGlobal.update()
	_on_window_close_requested()

func _edit_actor(id: String) -> void:
	var actor_to_edit
	for a in ActorMenuGlobal.loaded_actor_nodes:
		if(a.actor_id == id):
			actor_to_edit = a
			actor_to_edit.actor_name = actor_name.text
			actor_to_edit.load_image_from_path(actor_texture.texture.load_path)

func _create_actor() -> void:
	if(actor_name.text.is_empty()):
		actor_name.text = "New Actor"
	if(actor_id.text.is_empty()):
		actor_id.text = ActorMenuGlobal.generate_id()
	if(actor_texture.texture != null):
		ActorMenuGlobal.create_actor_item(actor_name.text, actor_id.text, actor_texture.texture.load_path)
	else:
		ActorMenuGlobal.create_actor_item(actor_name.text, actor_id.text, "")

func set_up_for_edit(name: String, id: String, picture: Texture2D) -> void:
	actor_name.text = name
	actor_id.text = id
	actor_texture.texture = picture
