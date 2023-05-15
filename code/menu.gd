extends Control

@onready var PLAYER = get_node("../../player");
@onready var TEMP_PLATFORM = get_node("../../temp");
@onready var MENU_CAMERA = get_node("../../Camera2D");
@onready var PLAYER_CAMERA = get_node("../../player/Camera2D")
@onready var papa = get_node("../");

func _ready():
	get_node("../intro").play("intro");
	get_tree().paused = true;
	$logo/handler.play("idle");

func _process(_delta):
	if Input.is_action_just_pressed("continue"):
		get_node("../../menu theme").stop();
		get_node("../../level theme").play();
		$handler.play("fadeout");
		await get_tree().create_timer(1).timeout;
		loadGame();

func loadGame():
	get_tree().paused = false;
	PLAYER.visible = true;
	PLAYER.jump();
	TEMP_PLATFORM.queue_free();
	await get_tree().create_timer(.5).timeout;
	MENU_CAMERA.set_enabled(false);
	PLAYER_CAMERA.set_enabled(true);
	papa.queue_free();
