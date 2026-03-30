@tool
extends Label

@export var hub_name: String
@export var hub_id: String

func _ready() -> void:
	$".".text = hub_name
