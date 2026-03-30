@tool
extends Control

var actor_item_scene = load("res://addons/node_based_dialogue_system/SceneView/actor_scene_item.tscn")

@onready var actor_list = $Window/Panel/ChooseActorLabel/ActorList

func _ready() -> void:
	SceneViewGlobal.register_create_window(self)
	_load_actors()

func _load_actors() -> void:
	for a in ActorMenuGlobal.loaded_actor_nodes:
		var actor_item = actor_item_scene.instantiate()
		actor_item.actor_name = a.actor_name
		actor_item.actor_id = a.actor_id
		actor_item.load_image_from_path(a.actor_texture.load_path)
		actor_list.add_child(actor_item)


func _on_window_close_requested() -> void:
	self.queue_free()
