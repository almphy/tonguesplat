extends StaticBody2D

@export var RESPAWN_POSITION: Vector2
@onready var FADE = get_node("../fade")

func _on_touchable_body_entered(_body):
	FADE.play("fade out inner")
	await get_tree().create_timer(1).timeout
	get_node("../player").set_position(RESPAWN_POSITION)
	FADE.play("fade in")
