extends Area2D

@export var DESTINATION: String
@onready var FADE_HANDLER = get_node("../fade")

func _on_body_entered(body):
	if body.get_name() == "player":
		FADE_HANDLER.play("fade out")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/"+DESTINATION+".tscn")
