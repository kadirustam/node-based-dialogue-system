@tool
extends Control

var condition_menu_item_scene = load("res://addons/node_based_dialogue_system/SceneView/condition_menu_item.tscn")

func _ready() -> void:
	SceneViewGlobal.register_create_window(self)
	for condition in ConditionMenuGlobal.loaded_conditions:
		var condition_menu_item = condition_menu_item_scene.instantiate()
		condition_menu_item.set_up_condition_node(condition.condition_name, condition.condition_id, condition.condition_type)
		$Window/Panel/ChooseConditionLabel/VBoxContainer.add_child(condition_menu_item)

func _on_window_close_requested() -> void:
	self.queue_free()
