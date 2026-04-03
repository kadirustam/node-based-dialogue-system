@tool
extends Node

var scene_item_scene = load("res://addons/node_based_dialogue_system/SceneMenu/scene_item.tscn")
var scene_view_scene = load("res://addons/node_based_dialogue_system/SceneView/scene_view.tscn")

@export var loaded_scenes: Array = []
var selected_scene: Node
var scene_list: VBoxContainer
var chars: Array = ['a', 'b', 'c', 'd']

func _ready() -> void:
	load_scenes()

func create_scene_item(name: String, id: String) -> void:
	var scene = scene_item_scene.instantiate()
	scene.set_up_scene_item(name, id)
	loaded_scenes.append(scene)
	save_scenes()
	update()

func update() -> void:
	if(scene_list != null):
		var children = scene_list.get_children()
		for scene in loaded_scenes:
			if(!children.has(scene)):
				scene_list.add_child(scene)

func has_id(id: String) -> bool:
	for s in loaded_scenes:
		if(s.scene_id == id):
			return true
	return false

func set_selected_scene(scene: Node) -> void:
	if(selected_scene != null):
		selected_scene.toggle_selected()
	selected_scene = scene

func generate_id() -> String:
	var id: String
	id = str(randi_range(0,9)) + chars.pick_random() + str(randi_range(10000,99999))
	if(!has_id(id)):
		return id
	else:
		return generate_id()

func load_scene_list(list: VBoxContainer) -> void:
	scene_list = list

func remove_selected_scene() -> void:
	if(selected_scene != null):
		for s in loaded_scenes:
			if(s.scene_id == selected_scene.scene_id):
				scene_list.remove_child(selected_scene)
				loaded_scenes.erase(s)
				selected_scene.toggle_selected()
				selected_scene = null
				save_scenes()
				return

func save_scenes() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/scenes/scenes.json"
	var json_string = JSON.stringify(save_scenes_to_json(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func load_scenes() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/scenes/scenes.json"
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		load_scenes_from_json(json_file.data)
	else:
		return

func save_scenes_to_json() -> Dictionary:
	var dict_to_json: Dictionary
	for s in loaded_scenes:
		dict_to_json[s] = {"scene_name": s.scene_name, "scene_id": s.scene_id}
	return dict_to_json

func load_scenes_from_json(json_data: Dictionary) -> void:
	for s in json_data:
		var scene_item = scene_item_scene.instantiate()
		scene_item.scene_name = json_data.get(s)["scene_name"]
		scene_item.scene_id = json_data.get(s)["scene_id"]
		loaded_scenes.append(scene_item)
	update()

func add_scene_to_container() -> void:
	var scene_view = scene_view_scene.instantiate()
	get_node("/root/Toolbar/TabContainer").add_child(scene_view)
