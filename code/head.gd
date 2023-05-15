extends Sprite2D

@onready var BODY = get_node("../body");
@onready var HEAD = self;
@onready var TONGUE = get_node("../tongue")
@onready var MOUSEPOS = get_node("../mousepos");
@export var SECRET_DOORS: int

var tempsus = preload("res://objects/temp.tscn");

const X: int = -135;
var MOUSE_POSITION;
var tongue_active: bool = false;
var rotation_lock: bool = false;

var buttons_pressed: int = 1;

const HEAD_OFFSET_RIGHT: Vector2 = Vector2(2, -5);
const HEAD_OFFSET_LEFT: Vector2 = Vector2(2, 5);
const HEAD_POSITION_RIGHT: Vector2 = Vector2(1, 6);
const HEAD_POSITION_LEFT: Vector2 = Vector2(-1, 6);

const TONGUE_POSITION_RIGHT: Vector2 = Vector2(3, 5);
const TONGUE_POSITION_LEFT: Vector2 = Vector2(-3, 5);

var temp_tongue_pos;

func _process(_delta):
	MOUSE_POSITION = MOUSEPOS.almphy_cursor_position();
	var mouseX = MOUSE_POSITION.x;

	if mouseX > X:
		BODY.flip_h = false;
		HEAD.flip_v = false;
		HEAD.set_offset(HEAD_OFFSET_RIGHT);
		if not tongue_active:
			TONGUE.set_position(TONGUE_POSITION_RIGHT);
		HEAD.set_position(HEAD_POSITION_RIGHT);
	else:
		BODY.flip_h = true;
		HEAD.flip_v = true;
		HEAD.set_offset(HEAD_OFFSET_LEFT);
		if not tongue_active:
			TONGUE.set_position(TONGUE_POSITION_LEFT);
		HEAD.set_position(HEAD_POSITION_LEFT);
		
	if rotation_lock:
		look_at(-get_node("../tongue/sprite").to_local(get_position()));
	else:
		look_at(get_global_mouse_position());

	match Input.is_action_just_pressed("attack"):
		true:
			rotation_lock = true;
			$attack.play();
			match tongue_active:
				false:
					get_node("../tongue/Area2D").set_collision_layer_value(3, true);
					get_node("../tongue/Area2D").set_collision_mask_value(4, true);
					tongue_active = true;
					TONGUE.set_freeze_enabled(false);
					TONGUE.set_visible(true);
					TONGUE.apply_central_impulse(MOUSE_POSITION)
	match Input.is_action_just_released("attack"):
		true:
			if mouseX > X:
				TONGUE.set_position(TONGUE_POSITION_RIGHT);
			else: 
				TONGUE.set_position(TONGUE_POSITION_LEFT);
			get_node("../tongue/Area2D").set_collision_layer_value(3, true);
			get_node("../tongue/Area2D").set_collision_mask_value(4, false);
			rotation_lock = false;
			TONGUE.set_visible(false);
			tongue_active = false;
			TONGUE.set_freeze_enabled(true);
		
func headHandler(x: String):
	if rotation_lock:
		HEAD.set_frame(3);
	else:
		match x:
			"default":
				HEAD.set_frame(0);
			"jump":
				HEAD.set_frame(1);
			"fall":
				HEAD.set_frame(2);

func _on_area_2d_body_entered(body):
	var button_node = str(body.get_owner().get_name());
	
	match button_node:
		"secret":
			var secrets: Array = []
			get_node("../../buttons/secret/anim").play("down")
			get_node("../../buttons/secret/activate").play()

			for i in SECRET_DOORS:
				secrets.push_back("secret" + str(i))

			for i in secrets.size():
				get_node("../../blastdoors/" + secrets[i] + "/animations").play("open")
		
		_:
			if buttons_pressed == int(button_node):
				buttons_pressed+=1;
				get_node("../../blastdoors/" + str(button_node) + "/animations").play("open");
				get_node("../../buttons/" + str(button_node) + "/anim").play("down");
				get_node("../../buttons/" + str(button_node) + "/activate").play();
	
