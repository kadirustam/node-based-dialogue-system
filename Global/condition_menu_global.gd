@tool
extends Node

var condition_menu_item_scene = load("res://addons/node_based_dialogue_system/ConditionMenu/condition_menu_item.tscn")

@onready var condition_list

var selected_condition
var loaded_conditions: Array = []

var chars = ['e', 'f', 'g']

func _ready() -> void:
	load_conditions()

func create_condition_item(name: String, id: String, type: String) -> void:
	var condition_menu_item = condition_menu_item_scene.instantiate()
	condition_menu_item.set_up_condition(name, id, type)
	loaded_conditions.append(condition_menu_item)
	save_conditions()
	update()

func update() -> void:
	if(condition_list != null):
		var children = condition_list.get_children()
		for condition in loaded_conditions:
			if(!children.has(condition)):
				condition_list.add_child(condition)

func remove_selected_condition() -> void:
	for condition in loaded_conditions:
		if(selected_condition.condition_id == condition.condition_id):
			condition_list.remove_child(selected_condition)
			loaded_conditions.erase(condition)
			save_conditions()

func load_condition_list(list: Node) -> void:
	condition_list = list

func set_selected_condition(item: Node) -> void:
	if(selected_condition != null):
		selected_condition.toggle_selected()
	item.toggle_selected()
	selected_condition = item

func generateId() -> String:
	var id: String
	id = str(randi_range(0,9)) + chars.pick_random() + str(randi_range(10000,99999))
	if(!has_id(id)):
		return id
	else:
		return generateId()

func has_id(id: String) -> bool:
	for condition in loaded_conditions:
		if(condition.condition_id == id):
			return true
	return false

func save_conditions() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/conditions/conditions.json"
	var json_string = JSON.stringify(save_scenes_to_json(), "\t")
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(json_string)

func load_conditions() -> void:
	var path = "res://addons/node_based_dialogue_system/SaveData/conditions/conditions.json"
	var json_file_content = FileAccess.get_file_as_string(path)
	var json_file = JSON.new()
	var error = json_file.parse(json_file_content)
	if error == OK:
		load_scenes_from_json(json_file.data)
	else:
		return

func save_scenes_to_json() -> Dictionary:
	var dict_to_json: Dictionary
	for condition in loaded_conditions:
		dict_to_json[condition] = {"condition_name": condition.condition_name, "condition_id": condition.condition_id, "condition_type": condition.condition_type}
	return dict_to_json

func load_scenes_from_json(json_data: Dictionary) -> void:
	for condition in json_data:
		create_condition_item(json_data.get(condition)["condition_name"], json_data.get(condition)["condition_id"], json_data.get(condition)["condition_type"])
