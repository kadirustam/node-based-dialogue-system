@tool
extends Node

var actor_edit = load("res://addons/node_based_dialogue_system/ActorMenu/actor_edit.tscn")
var actor_item_scene = load("res://addons/node_based_dialogue_system/ActorMenu/actor_edit_item.tscn")
var actor_edit_screen = load("res://addons/node_based_dialogue_system/ActorMenu/actor_edit_screen.tscn")
var actor_list: Node

var selected_actor: Node
@export var loaded_actor_nodes: Array = []

var chars = ['l', 'm', 'n']

func create_actor_item(name: String, id: String, img_path: String) -> void:
	var actor = actor_item_scene.instantiate()
	actor.set_up_actor_item(name, id, img_path)
	loaded_actor_nodes.append(actor)
	save_actors()
	update()

func has_id(id: String) -> bool:
	for a in loaded_actor_nodes:
		if(a.actor_id == id):
			return true
	return false

func load_json(json_data: Dictionary) -> void:
	for a in json_data:
		var actor_item = actor_item_scene.instantiate()
		actor_item.actor_name = json_data.get(a)["actor_name"]
		actor_item.actor_id = json_data.get(a)["actor_id"]
		actor_item.load_image_from_path(json_data.get(a)["actor_texture"])
		loaded_actor_nodes.append(actor_item)
	update()

func save_actors() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/actors/actors.json"
	var json_string = JSON.stringify(save_json(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func load_actors() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/actors/actors.json"
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		load_json(json_file.data)
	else:
		return

func save_json() -> Dictionary:
	var dict_to_json: Dictionary
	for a in loaded_actor_nodes:
		dict_to_json[a] = {"actor_id": a.actor_id, "actor_name": a.actor_name, "actor_texture": a.get_actor_texture()}
	print(dict_to_json)
	return dict_to_json

func generate_id() -> String:
	var id: String
	id = str(randi_range(0,9)) + chars.pick_random() + str(randi_range(10000,99999))
	if(!has_id(id)):
		return id
	else:
		return generate_id()

func update() -> void:
	if(actor_list != null):
		var children = actor_list.get_children()
		for actor in loaded_actor_nodes:
			if(!children.has(actor)):
				actor_list.add_child(actor)

func load_actor_list(list: Node) -> void:
	actor_list = list

func set_selected_actor(item: Node) -> void:
	if(selected_actor != null):
		selected_actor.toggle_selected()
	item.toggle_selected()
	selected_actor = item

func remove_selected_actor() -> void:
	if(selected_actor):
		for actor in loaded_actor_nodes:
			if(selected_actor.actor_id == actor.actor_id):
				actor_list.remove_child(selected_actor)
				loaded_actor_nodes.erase(actor)
				selected_actor.toggle_selected()
				selected_actor = null
				save_actors()
				return

func edit_selected_actor() -> void:
	if(selected_actor):
		var actor_edit_instance = actor_edit_screen.instantiate()
		actor_list.add_child(actor_edit_instance)
		actor_edit_instance.set_up_for_edit(selected_actor.actor_name, selected_actor.actor_id, selected_actor.actor_texture)
		selected_actor.toggle_selected()
		selected_actor = null

func get_actor_from_list(actor_name: String) -> Node:
	for actor in loaded_actor_nodes:
		if actor.actor_name == actor_name:
			return actor
	return null
