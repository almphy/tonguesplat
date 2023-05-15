extends ParallaxLayer

var BACKGROUND_SPEED: float = -10;

func _process(delta):
	self.motion_offset.x += BACKGROUND_SPEED * delta;
