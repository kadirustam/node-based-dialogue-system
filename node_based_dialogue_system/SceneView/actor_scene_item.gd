@tool
extends Panel

@export var actor_name: String
@export var actor_id: String
@export var actor_texture: Texture2D


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

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SceneViewGlobal.create_dialogue_node(self, "")
