@tool
extends Node

@export var dialogue_ui: Control

func start_conversation(scene: Dictionary) -> void:
	var parser = DialogueParser.new(scene)
	dialogue_ui.instantiate()

func end_conversation() -> void:
	dialogue_ui.queue_free()
