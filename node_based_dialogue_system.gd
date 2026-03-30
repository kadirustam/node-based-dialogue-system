@tool
extends EditorPlugin

var toolbar
var main_scene
var actor_scene
var condition_edit

const ACTOR_GLOBALS_NAME = "ActorMenuGlobal"
const ACTOR_GLOBALS_PATH = "res://addons/node_based_dialogue_system/Global/actor_menu_global.gd"

const CONDTITION_GLOBALS_NAME = "ConditionMenuGlobal"
const CONDTITION_GLOBALS_PATH = "res://addons/node_based_dialogue_system/Global/condition_menu_global.gd"

const SCENE_GLOBALS_NAME = "SceneMenuGlobal"
const SCENE_GLOBALS_PATH = "res://addons/node_based_dialogue_system/Global/scene_menu_global.gd"

const SCENE_VIEW_GLOBALS_NAME = "SceneViewGlobal"
const SCENE_VIEW_GLOBALS_PATH = "res://addons/node_based_dialogue_system/Global/scene_view_global.gd"

func _enable_plugin() -> void:
	add_autoload_singleton(ACTOR_GLOBALS_NAME, ACTOR_GLOBALS_PATH)
	add_autoload_singleton(CONDTITION_GLOBALS_NAME, CONDTITION_GLOBALS_PATH)
	add_autoload_singleton(SCENE_GLOBALS_NAME, SCENE_GLOBALS_PATH)
	add_autoload_singleton(SCENE_VIEW_GLOBALS_NAME, SCENE_VIEW_GLOBALS_PATH)

func _disable_plugin() -> void:
	remove_autoload_singleton(ACTOR_GLOBALS_NAME)
	remove_autoload_singleton(CONDTITION_GLOBALS_NAME)
	remove_autoload_singleton(SCENE_GLOBALS_NAME)
	remove_autoload_singleton(SCENE_VIEW_GLOBALS_NAME)


func _enter_tree() -> void:
	toolbar = preload("res://addons/node_based_dialogue_system/toolbar.tscn").instantiate()
	condition_edit = preload("res://addons/node_based_dialogue_system/ConditionMenu/condition_menu.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(toolbar)
	_make_visible(false)

func _exit_tree() -> void:
	if toolbar:
		toolbar.queue_free()


func _has_main_screen():
	return true


func _get_plugin_name():
	return "NBDS"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("EditBezier", "EditorIcons")


func _make_visible(visible):
	if toolbar:
		toolbar.visible = visible
