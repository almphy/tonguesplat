extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

@onready var CHARACTER = $body;
@onready var ANIMATIONS = $animations;
@onready var COYOTE_TIME = $coyotetime;
@onready var CAMERA = $Camera2D;
@onready var CAMERA_TIMER = $fall;
@onready var JUMP_PARTICLES = $body/jump;

@export var state = 0;
#0 - idle
#1 - walking
#2 - jumping
#3 - falling
#4 - attacking

var moving: bool = false;
var was_on_floor: bool;

var jumps: int = 0;
var max_jumps: int = 2;
var speed: int = 55;
var min_speed: int = 55;
var max_speed: int = 80;
var jump_height: float = -245.0;
var min_jump_height: float = -180.0;
var max_jump_height: float = -245.0;

var temp = false;

func _physics_process(delta):
	_state_machine();

	match jumps:
		2:
			speed = max_speed
			jump_height = min_jump_height
		_:
			speed = min_speed
			jump_height = max_jump_height
	
	match jumps:
		0:
			JUMP_PARTICLES.set_position(Vector2(0, 10));
		_:
			JUMP_PARTICLES.set_position(Vector2(0, 7));
	
	if state == 3 and not is_on_floor():
		if not temp:
			CAMERA_TIMER.start();
			temp = true;
	else:
		CAMERA_TIMER.stop();
		temp = false;
			
	if state == 1 and is_on_floor():
		match CHARACTER.flip_h:
			true:
				$body/runright.set_emitting(false);
				$body/runleft.set_emitting(true);
			false:
				$body/runright.set_emitting(true);
				$body/runleft.set_emitting(false);
	else:
		$body/runright.set_emitting(false);
		$body/runleft.set_emitting(false);
		
	match is_on_floor():
		false:
			velocity.y += gravity * delta
		
	match Input.is_action_just_pressed("jump"):
		true:
			jump()
			
	var direction = Input.get_axis("left", "right")
	if direction:
		moving = true;
		velocity.x = direction * speed;
	else:
		moving = false;
		velocity.x = move_toward(velocity.x, 0, speed);
		
	was_on_floor = is_on_floor();
	move_and_slide();
	
	queue_redraw();
		
func _draw():
	draw_multiline([$tonguestartpoint.get_position(), -$tongue/sprite.to_local(get_position())], Color.BLACK, 3.0);
	draw_multiline([$tonguestartpoint.get_position(), -$tongue/sprite.to_local(get_position())], Color.html("#7944cc"), 1.0);
	
func jump():
	if jumps < max_jumps:
		$jump.play();
		JUMP_PARTICLES.restart();
		jumps+=1;
		velocity.y = jump_height;
			
func _state_machine():
		
	if is_on_floor() and not Input.is_action_pressed("jump") and not moving: state = 0;
	if is_on_floor() and not Input.is_action_pressed("jump") and moving: state = 1;
	if not is_on_floor() and Input.is_action_pressed("jump"): state = 2;
	if not is_on_floor() and not Input.is_action_pressed("jump"): state = 3;
		
	match state:
		0: #idle
			jumps = 0;
			var tween = get_tree().create_tween()
			tween.tween_property(CAMERA, "offset", Vector2(0, -20), 1);
			ANIMATIONS.play("idle");
		1: #walking
			jumps = 0;
			var tween = get_tree().create_tween()
			tween.tween_property(CAMERA, "offset", Vector2(0, -20), 1);
			ANIMATIONS.play("walk");
		2: #jumping
			if jumps < max_jumps:
				ANIMATIONS.play("jump");
		3: #falling
			ANIMATIONS.play("fall");
		4: #attacking
			pass

func collectableManager(x: String):
	match x:
		"coin":
			pass 
		"veggies":
			pass

func _on_deathtrigger_body_entered(_body):
	pass

